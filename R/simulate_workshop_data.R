## -----------------------------------------------------------------------
## Shared data generator for the statistical-thinking workshop
##
## Produces the small teaching dataset used by 2026-09-workshop-modules.Rmd:
##
##     8 hepatocyte lots x 2 compounds x 3 technical wells = 48 measurements
##     of CellTiter-Glo viability at ONE screening concentration,
##     run over 2 weekdays, with a vehicle-reference day effect,
##     one air-bubble well, one genuinely sensitive lot,
##     and lot-dependent technical variance.
##
## Relationship to 2026-09-statistical-thinking.Rmd (the instructor's
## technical appendix): same assay, same compounds, same day effect. Two
## deliberate differences, both made for teaching rather than realism-in-
## the-appendix reasons:
##
##   1. Donor effects are CORRELATED across compounds here. A lot that is
##      generally more sensitive is more sensitive to both compounds. The
##      appendix draws the two IC50s independently, which would make the
##      paired/unpaired contrast in Module 5 vanish.
##   2. Donor-to-donor spread is larger (GSD ~2.8 rather than ~1.4). With a
##      tight GSD the two compounds never overlap and there is nothing for
##      pairing to reveal. GSD 2.8 is well within what primary hepatocyte
##      lots actually show.
##   3. Both compounds are given the same Hill slope, and the readout
##      concentration is the geometric mean of the two IC50 values. This
##      keeps every lot on the informative part of both curves, which is
##      what makes the lot effect additive on the viability scale.
##
## Usage:
##     sim <- simulate_workshop_data()          # defaults
##     sim <- simulate_workshop_data(seed = 42) # anything can be overridden
##     str(sim, max.level = 1)
## -----------------------------------------------------------------------

suppressPackageStartupMessages({
  library(tidyverse)
})

## Default settings -------------------------------------------------------
workshop_params <- function(...) {
  defaults <- list(
    seed            = 20260919,

    ## ground truth, shared with the appendix document
    ic50_A          = 10,     # uM
    ic50_B          = 50,     # uM   -> true separation 5x
    hill_A          = 1.5,
    hill_B          = 1.5,

    ## The one concentration the workshop dataset is read out at.
    ## Chosen as the geometric mean of the two reference IC50 values, so
    ## CPD-A sits near 23% and CPD-B near 77% of vehicle: both compounds are
    ## on the informative part of their curve, for every lot. Read out much
    ## below or above this and one compound saturates, the lot effect stops
    ## being additive on the percentage scale, and pairing stops helping.
    screen_conc     = round(sqrt(10 * 50), 1),   # 22.4 uM

    ## the decision threshold, fixed BEFORE the data are seen
    mcid_fold       = 3,      # a 3-fold IC50 shift is what we would act on

    ## variance structure
    donor_gsd       = 2.2,    # lot-to-lot spread, SHARED by both compounds
    compound_gsd    = 1.15,   # extra, compound-specific lot deviation
    n_wells         = 3,      # technical replicate wells per lot x compound
    n_vehicle       = 6,      # vehicle wells per plate
    n_blank         = 3,      # no-cell blank wells per plate

    ## the day effect: Friday vehicle wells read high, compound wells do not
    friday_vehicle_gain = 0.20,

    ## perturbation A - one genuinely sensitive lot (biology, not error)
    sensitive_donor  = "HH7",
    sensitive_fold   = 3.0,   # IC50 3x LOWER for both compounds

    ## perturbation B - one air bubble in one well (technical, documented)
    bubble_donor     = "HH2",
    bubble_compound  = "CPD-B",
    bubble_replicate = 2L,
    bubble_gain      = 0.35,  # that single well reads at 35% of what it should

    outdir = file.path("output", "workshop")
  )
  modifyList(defaults, list(...))
}

## Four-parameter-free Hill curve ----------------------------------------
hill_viability <- function(conc, ic50, hill) 1 / (1 + (conc / ic50)^hill)

## -----------------------------------------------------------------------
simulate_workshop_data <- function(...) {

  p <- workshop_params(...)
  set.seed(p$seed)

  ## --- the eight lots, same identities as the appendix document ---------
  donors <- tibble(
    donor_id    = c("HH1", "HH2", "HH3", "HH4",
                    "HH5", "HH6", "HH7", "HH8"),
    donor_sex   = c("F", "M", "F", "M", "M", "F", "F", "M"),
    donor_age   = c(34L, 52L, 61L, 45L, 29L, 58L, 41L, 66L),
    vehicle_rlu = c(2.10, 1.68, 2.44, 1.92, 2.28, 1.55, 2.02, 1.79) * 1e6,
    blank_rlu   = 1.2e4,
    ## plating uniformity differs between lots: unequal technical variance
    tech_cv     = c(0.045, 0.050, 0.115, 0.055, 0.060, 0.105, 0.050, 0.048)
  ) %>%
    mutate(donor_index = row_number())

  ## --- lot sensitivity, SHARED across the two compounds -----------------
  ## log10 IC50 = log10(reference) + shared lot effect + compound deviation
  donor_effect <- donors %>%
    transmute(
      donor_id,
      lot_log10 = rnorm(n(), 0, log10(p$donor_gsd))) %>%
    mutate(
      ## the designated sensitive lot is placed by construction, not by luck,
      ## so the story is the same every time the document is knitted
      lot_log10 = if_else(donor_id == p$sensitive_donor,
                          -log10(p$sensitive_fold), lot_log10),
      sensitive = donor_id == p$sensitive_donor)

  truth <- expand_grid(donor_id = donors$donor_id,
                       compound = c("CPD-A", "CPD-B")) %>%
    left_join(donor_effect, by = "donor_id") %>%
    mutate(
      ic50_ref  = if_else(compound == "CPD-A", p$ic50_A, p$ic50_B),
      hill      = if_else(compound == "CPD-A", p$hill_A, p$hill_B),
      cpd_log10 = rnorm(n(), 0, log10(p$compound_gsd)),
      ic50_true = ic50_ref * 10^(lot_log10 + cpd_log10),
      viab_true = 100 * hill_viability(p$screen_conc, ic50_true, hill))

  ## --- run-day allocation: two designs on the same eight lots -----------
  ## Blocked  : day follows the LOT, so both compounds of a lot run together
  ## Confounded: day follows the COMPOUND, perfectly aliased
  schedule <- expand_grid(donor_id = donors$donor_id,
                          compound = c("CPD-A", "CPD-B")) %>%
    left_join(donors, by = "donor_id") %>%
    mutate(
      weekday_blocked    = if_else(donor_index <= 4L, "Friday", "Monday"),
      weekday_confounded = if_else(compound == "CPD-A", "Friday", "Monday"))

  ## --- well-level simulation -------------------------------------------
  simulate_wells <- function(day_column, design_label) {

    plates <- schedule %>%
      mutate(weekday = .data[[day_column]],
             design  = design_label,
             plate_id = sprintf("%s-%s-%s",
                                substr(design_label, 1, 1),
                                str_remove(donor_id, "HH"),
                                str_remove(compound, "CPD-"))) %>%
      left_join(truth %>% select(donor_id, compound, ic50_true, hill, viab_true),
                by = c("donor_id", "compound"))

    well_grid <- bind_rows(
      tibble(well_type = "test article", replicate = seq_len(p$n_wells)),
      tibble(well_type = "vehicle",      replicate = seq_len(p$n_vehicle)),
      tibble(well_type = "no-cell blank", replicate = seq_len(p$n_blank)))

    plates %>%
      expand_grid(well_grid) %>%
      mutate(
        conc_uM = if_else(well_type == "test article", p$screen_conc, 0),
        ## the day effect lives ONLY in the vehicle reference
        day_gain = if_else(well_type == "vehicle" & weekday == "Friday",
                           1 + p$friday_vehicle_gain, 1),
        ## the single air bubble
        bubble = well_type == "test article" &
                 donor_id == p$bubble_donor &
                 compound == p$bubble_compound &
                 replicate == p$bubble_replicate,
        well_gain = if_else(bubble, p$bubble_gain, 1),
        ## technical CV: lot-dependent, and larger as the signal falls
        well_cv = tech_cv + 0.12 * (1 - viab_true / 100),
        signal_true = case_when(
          well_type == "test article" ~ vehicle_rlu * viab_true / 100,
          well_type == "vehicle"      ~ vehicle_rlu * day_gain,
          TRUE                        ~ 0),
        noise = case_when(
          well_type == "no-cell blank" ~ rnorm(n(), 1, 0.10),
          well_type == "vehicle"       ~ rnorm(n(), 1, tech_cv),
          TRUE                         ~ rnorm(n(), 1, well_cv)),
        raw_rlu = round(pmax(
          signal_true * noise * well_gain + blank_rlu * rnorm(n(), 1, 0.08), 0)))
  }

  wells <- bind_rows(
    simulate_wells("weekday_blocked",    "Blocked"),
    simulate_wells("weekday_confounded", "Confounded")) %>%
    mutate(design  = factor(design, levels = c("Blocked", "Confounded")),
           weekday = factor(weekday, levels = c("Friday", "Monday")))

  ## --- normalisation: per plate, blank-subtracted, vehicle = 100% -------
  ctg <- wells %>%
    group_by(design, plate_id) %>%
    mutate(
      plate_blank_rlu   = median(raw_rlu[well_type == "no-cell blank"]),
      plate_vehicle_rlu = median(raw_rlu[well_type == "vehicle"]),
      viability_pct     = 100 * (raw_rlu - plate_blank_rlu) /
                                (plate_vehicle_rlu - plate_blank_rlu)) %>%
    ungroup() %>%
    mutate(across(c(viability_pct), ~ round(.x, 1)))

  ## --- the 48-row teaching table (blocked design, test-article wells) ---
  make_viab <- function(design_label) {
    ctg %>%
      filter(design == design_label, well_type == "test article") %>%
      transmute(
        donor_id, donor_sex, donor_age,
        compound, weekday, plate_id,
        well = sprintf("%s%02d", LETTERS[replicate], round(p$screen_conc)),
        replicate, conc_uM,
        raw_rlu,
        plate_vehicle_rlu, plate_blank_rlu,
        viability_pct,
        bubble) %>%
      arrange(donor_id, compound, replicate)
  }

  viab       <- make_viab("Blocked")
  viab_conf  <- make_viab("Confounded")

  ## --- what the pre-registered 3-fold rule means on this readout --------
  ## The threshold has to be expressed on the SAME scale, and in the SAME
  ## lots, as the estimate it will be compared with. Translating it at a
  ## hypothetical "reference lot" is not enough: the viability difference
  ## produced by a given potency shift is largest for lots sitting in the
  ## middle of the curve and smaller for lots at either end. So we ask the
  ## question directly - if CPD-B were exactly `mcid_fold` times less potent
  ## than CPD-A in each of THESE lots, how many percentage points of
  ## viability would separate them, on average?
  mcid_by_donor <- truth %>%
    filter(compound == "CPD-A") %>%
    transmute(
      donor_id,
      viab_A        = 100 * hill_viability(p$screen_conc, ic50_true, hill),
      viab_at_mcid  = 100 * hill_viability(p$screen_conc,
                                           ic50_true * p$mcid_fold, hill),
      mcid_pp       = viab_at_mcid - viab_A)

  thresholds <- tibble(
    mcid_fold      = p$mcid_fold,
    screen_conc    = p$screen_conc,
    true_fold      = p$ic50_B / p$ic50_A,
    ## the same translation done naively, at the reference lot, for contrast
    mcid_pp_naive  = 100 * hill_viability(p$screen_conc, p$ic50_A * p$mcid_fold, p$hill_A) -
                     100 * hill_viability(p$screen_conc, p$ic50_A, p$hill_A),
    mcid_pp        = mean(mcid_by_donor$mcid_pp))

  list(params     = p,
       donors     = donors,
       truth      = truth,
       schedule   = schedule,
       wells      = wells,
       ctg        = ctg,
       viab       = viab,        # <- the 48-row workshop dataset
       viab_conf  = viab_conf,   # <- same lots, confounded scheduling
       mcid_by_donor = mcid_by_donor,
       thresholds = thresholds)
}

## Convenience: donor-level means, the analysis unit ----------------------
donor_means <- function(viab) {
  viab %>%
    group_by(donor_id, donor_sex, donor_age, compound, weekday) %>%
    summarise(n_wells   = n(),
              viability = mean(viability_pct),
              sd_wells  = sd(viability_pct),
              .groups   = "drop")
}

## -----------------------------------------------------------------------
## One synthetic study, drawn from the same generative model.
## Used by Module 6 (what a null world looks like) and Module 8 (power).
##
##   n_donors  independent hepatocyte lots
##   n_wells   technical replicate wells per lot x compound
##   fold      true potency separation; fold = 1 is the null world
##
## Returns one row: the paired estimate, its interval, its p-value, and the
## relevance threshold translated into these particular lots.
## -----------------------------------------------------------------------
simulate_study <- function(n_donors = 8, n_wells = 3, fold = 5,
                           p = workshop_params()) {

  ## lot sensitivity, shared by both compounds - this is what pairing removes
  ic50_A <- p$ic50_A * 10^rnorm(n_donors, 0, log10(p$donor_gsd))
  ic50_B <- ic50_A * fold * 10^rnorm(n_donors, 0, log10(p$compound_gsd))

  read_plate <- function(ic50) {
    v  <- 100 * hill_viability(p$screen_conc, ic50, p$hill_A)
    cv <- 0.05 + 0.12 * (1 - v / 100)          # noisier near the assay floor
    noise <- matrix(rnorm(n_donors * n_wells), nrow = n_donors)
    rowMeans(v * (1 + noise * cv))
  }

  d  <- read_plate(ic50_B) - read_plate(ic50_A)
  tt <- t.test(d)

  ## the 3-fold rule, translated into the lots this study happened to draw
  mcid <- mean(100 * hill_viability(p$screen_conc, ic50_A * p$mcid_fold, p$hill_A) -
               100 * hill_viability(p$screen_conc, ic50_A, p$hill_A))

  tibble(n_donors = n_donors, n_wells = n_wells, fold = fold,
         estimate = mean(d), lwr = tt$conf.int[1], upr = tt$conf.int[2],
         p_value = tt$p.value, mcid_pp = mcid,
         significant = tt$p.value < 0.05,
         calls_relevant = tt$conf.int[1] > mcid,
         calls_irrelevant = tt$conf.int[2] < mcid)
}

## Many studies at once ---------------------------------------------------
replicate_studies <- function(n_sim = 1000, ...) {
  map_dfr(seq_len(n_sim), function(i) simulate_study(...) %>% mutate(sim = i))
}
