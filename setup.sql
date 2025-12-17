DROP TABLE IF EXISTS game_activity_log;
DROP TABLE IF EXISTS game;
DROP TABLE IF EXISTS player;
DROP TABLE IF EXISTS tournament;

CREATE TABLE IF NOT EXISTS tournament(
    id   SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    pin VARCHAR(4)
);

CREATE TABLE IF NOT EXISTS stage_rules(
    stage SERIAL PRIMARY KEY,
    tournament_id INTEGER,
    double_checkout INTEGER DEFAULT FALSE,
    points INTEGER DEFAULT 501,
    legs INTEGER,
    FOREIGN KEY (tournament_id) REFERENCES tournament(id)
);

CREATE TABLE IF NOT EXISTS player(
    id SERIAL PRIMARY KEY,
    tournament_id INTEGER,
    nickname VARCHAR(100) NOT NULL,
    FOREIGN KEY (tournament_id) REFERENCES tournament(id)
);

CREATE TYPE game_status AS ENUM ('scheduled', 'active', 'over');

CREATE TABLE IF NOT EXISTS game(
    id SERIAL PRIMARY KEY,
    p1_id INTEGER,
    p2_id INTEGER,
    winner_id INTEGER DEFAULT NULL,
    status game_status NOT NULL,
    p1_score INTEGER NOT NULL,
    p2_score INTEGER NOT NULL,
    FOREIGN KEY (p1_id) REFERENCES player(id),
    FOREIGN KEY (p2_id) REFERENCES player(id),
    FOREIGN KEY (winner_id) REFERENCES player(id)
);

CREATE TABLE IF NOT EXISTS leg(
    id SERIAL PRIMARY KEY,
    game_id INTEGER,
    points_p1 INTEGER DEFAULT 0,
    points_p2 INTEGER DEFAULT 0,
    isFinished BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (game_id) REFERENCES game(id)
);

CREATE TYPE activity AS ENUM ('p1_wins_leg', 'p2_wins_leg', 'p1_wins_game', 'p2_wins_game');

CREATE TABLE game_activity(
     game_id INTEGER,
     scored_at TIMESTAMP DEFAULT now(),
     activity activity NOT NULL,
     FOREIGN KEY (game_id) REFERENCES game(id)
);

CREATE TABLE leg_activity(
    id SERIAL PRIMARY KEY,
    leg_id INTEGER,
    player_id INTEGER,
    dart1_score INTEGER DEFAULT 0,
    dart2_score INTEGER DEFAULT 0,
    dart3_score INTEGER DEFAULT 0,
    total_score INTEGER GENERATED ALWAYS AS (dart1_score + dart2_score + dart3_score) STORED,
    scored_at TIMESTAMP DEFAULT now(),
    FOREIGN KEY (leg_id) REFERENCES leg(id),
    FOREIGN KEY (player_id) REFERENCES player(id)
);