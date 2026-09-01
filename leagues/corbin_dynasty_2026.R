# =============================================================================
# League config: Corbin Dynasty League, 2026-2027 season
# Returns a config list consumed by run_all.R and app.R.
# To add another league, copy this file and edit the values.
# =============================================================================

list(
    league_id    = "1326807191797112832",
    league_tag   = "Corbin Dynasty",
    season_label = "2026-2027",
    data_dir     = "data/corbin_dynasty",

    # Preseason/roster strength scoring, used for (a) Glicko-2 initial ratings
    # and (b) the ROST SCORE column in League Stats > Summary.
    #   "fantasycalc" - computed live each run: sums FantasyCalc player values
    #                   (see is_dynasty/ppr below) per Sleeper roster, then
    #                   ranks teams 1-12 (1 = strongest roster).
    #   "manual"      - uses the roster_scores vector below instead.
    #   NULL          - disabled; all teams start at 1500, ROST SCORE hidden.
    roster_score_source = "manual",
    is_dynasty = TRUE,   # dynasty rosters carry over; FALSE = redraft values
    ppr        = 1,      # matches this league's full-PPR scoring

    # Season simulation (ffsimulator), feeds the "Simulated Seasons" tab.
    # Runs only in the weekly GitHub Action (heavy deps, not in the Shiny
    # app); set FALSE to skip it entirely for this league.
    enable_simulation = TRUE,
    sim_n_seasons = 250,  # more = smoother odds, slower CI run
    sim_n_weeks   = 14,   # matches this league's regular-season length (playoffs start week 15)

    # Manual preseason roster power ranking, only used because
    # roster_score_source == "manual" above. Owner supplied Borda voting
    # scores (higher = stronger, no ties); converted here to rank order and
    # then to a 1-12 "higher = stronger" score (13 - rank), ordered by
    # roster_id 1-12 (PlayerRatings::glicko2 z-scores this vector to seed
    # initial ratings at mean 1500 / SD 100):
    #   Borda scores: Jsproles 60, JoshHash 53, DT1104 49, KaisonO 44,
    #   blakebot 43, Swanner24 36, BradenDickerson99 30, CptnZacSparrow 25,
    #   jaystancil 16, jstancil 14, MCreekmore19 11, BoeJidenDad 9
    #   roster_id 1  jstancil            (rank 10) -> 3
    #   roster_id 2  Swanner24           (rank 6)  -> 7
    #   roster_id 3  jaystancil          (rank 9)  -> 4
    #   roster_id 4  blakebot            (rank 5)  -> 8
    #   roster_id 5  JoshHash            (rank 2)  -> 11
    #   roster_id 6  CptnZacSparrow      (rank 8)  -> 5
    #   roster_id 7  KaisonO             (rank 4)  -> 9
    #   roster_id 8  DT1104              (rank 3)  -> 10
    #   roster_id 9  Jsproles            (rank 1)  -> 12
    #   roster_id 10 BradenDickerson99   (rank 7)  -> 6
    #   roster_id 11 MCreekmore19        (rank 11) -> 2
    #   roster_id 12 BoeJidenDad         (rank 12) -> 1
    # Re-derive this vector each preseason before Week 1 of a new season.
    roster_scores = c(3, 7, 4, 8, 11, 5, 9, 10, 12, 6, 2, 1),

    # Canonical owner names keyed by Sleeper user_id (stable across seasons).
    # Set to NULL to use Sleeper display names.
    owner_map = data.frame(
      user_id = c("940759302413967360", "940786082025791488",
                  "941550205206405120", "959877038964322304",
                  "997340636179140608", "740335824771653632",
                  "473634364006068224", "968280927057055744",
                  "893209549510000640", "960029297014616064",
                  "600080890604879872", "997538193052364800"),
      owner   = c("Jayson Stancil", "Jay Stancil", "Josh Hash", "Dalton Terry",
                  "Kaison Osbourne", "Blake Botner", "Jaidyn Swanner",
                  "Braden Dickerson", "Zac Hash", "Jonas Sproles",
                  "Matthew Creekmore", "Milam Watkins"),
      stringsAsFactors = FALSE
    )

    # No history_seed needed: this league's Sleeper chain (2026 -> 2025 ->
    # 2024 -> 2023, previous_league_id NULL at 2023) is entirely API-native,
    # confirmed by walking the chain via the Sleeper API, so
    # fetch_league_history() reconstructs champions/all-time records/H2H for
    # every season live with no manual seed data required.
)
