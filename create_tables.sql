----------------
-- DIMENSION TABLES
----------------
DROP TABLE IF EXISTS :schema.DIM_SNAPSHOTS CASCADE;
CREATE TABLE :schema.DIM_SNAPSHOTS
(
    SNAPSHOT_ID TEXT,
    APPLICATION_ID INT,
    APPLICATION_NAME TEXT,
    DATE DATE,
    ANALYSIS_DATE DATE,
    SNAPSHOT_NUMBER INT,
    IS_LATEST BOOLEAN,
    YEAR INT,
    YEAR_QUARTER TEXT,
    YEAR_MONTH TEXT,
    YEAR_WEEK TEXT,
    LABEL TEXT,
    CONSTRAINT DATES_PKEY PRIMARY KEY (SNAPSHOT_ID)
);

DROP TABLE IF EXISTS :schema.DIM_RULES CASCADE;
CREATE TABLE :schema.DIM_RULES
(
    RULE_ID TEXT,
    RULE_NAME TEXT,
    TECHNICAL_CRITERION_NAME TEXT,  
    IS_CRITICAL BOOLEAN,
    WEIGHT NUMERIC,
    WEIGHT_ARCHITECTURAL_DESIGN NUMERIC,
    WEIGHT_CHANGEABILITY NUMERIC,
    WEIGHT_DOCUMENTATION NUMERIC,
    WEIGHT_EFFICIENCY NUMERIC,
    WEIGHT_MAINTAINABILITY NUMERIC,
    WEIGHT_PROGRAMMING_PRACTICES NUMERIC,
    WEIGHT_ROBUSTNESS NUMERIC,  
    WEIGHT_SECURITY NUMERIC,
    WEIGHT_TOTAL_QUALITY_INDEX NUMERIC,
    WEIGHT_TRANSFERABILITY NUMERIC,
    CONSTRAINT DIM_RULES_PKEY PRIMARY KEY (RULE_ID)
);

----------------
-- APPLICATIONS MEASURES TABLES
----------------
  
DROP TABLE IF EXISTS :schema.APP_VIOLATIONS_MEASURES CASCADE;
CREATE TABLE :schema.APP_VIOLATIONS_MEASURES
(
    SNAPSHOT_ID TEXT,
    RULE_ID TEXT,
    TECHNOLOGY TEXT,  
    METRIC_ID INT,
    NB_VIOLATIONS INT,
    NB_TOTAL_CHECKS INT,
    VIOLATION_RATIO NUMERIC,
    COMPLIANCE_RATIO NUMERIC,
    CONSTRAINT APP_VIOLATIONS_MEASURES_PKEY PRIMARY KEY (SNAPSHOT_ID, RULE_ID, TECHNOLOGY),
    FOREIGN KEY (RULE_ID) REFERENCES :schema.DIM_RULES (RULE_ID),
    FOREIGN KEY (SNAPSHOT_ID) REFERENCES :schema.DIM_SNAPSHOTS(SNAPSHOT_ID)
);

DROP TABLE IF EXISTS :schema.APP_SIZING_MEASURES CASCADE;
CREATE TABLE :schema.APP_SIZING_MEASURES
(
    SNAPSHOT_ID TEXT,
    NB_ARTIFACTS INT,
    NB_CODE_LINES INT,
    NB_COMMENT_LINES INT,
    NB_COMMENTED_OUT_CODE_LINES INT,
    NB_CRITICAL_VIOLATIONS INT,
    NB_DECISION_POINTS INT,
    NB_FILES INT,
    NB_TABLES INT,
    NB_VIOLATIONS INT,
    NB_VIOLATIONS_EXCLUDED INT,    
    NB_VIOLATIONS_FIXED_ACTION_PLAN	INT,
    NB_VIOLATIONS_PENDING_ACTION_PLAN INT,        
    TECHNICAL_DEBT_DENSITY NUMERIC,
    TECHNICAL_DEBT_TOTAL NUMERIC,
    CONSTRAINT APP_SIZING_MEASURES_PKEY PRIMARY KEY (SNAPSHOT_ID),
    FOREIGN KEY (SNAPSHOT_ID) REFERENCES :schema.DIM_SNAPSHOTS(SNAPSHOT_ID)
);

DROP TABLE IF EXISTS :schema.APP_FUNCTIONAL_SIZING_MEASURES CASCADE;
CREATE TABLE :schema.APP_FUNCTIONAL_SIZING_MEASURES
(
    SNAPSHOT_ID TEXT,
    EFFORT_COMPLEXITY NUMERIC,
    EQUIVALENCE_RATIO NUMERIC,
    NB_DATA_FUNCTIONS_POINTS INT,
    NB_TOTAL_POINTS INT,
    NB_TRANSACTIONAL_FUNCTIONS_POINTS INT,
    NB_TRANSACTIONS INT,
    CONSTRAINT APP_FUNCTIONAL_SIZING_MEASURES_PKEY PRIMARY KEY (SNAPSHOT_ID),
    FOREIGN KEY (SNAPSHOT_ID) REFERENCES :schema.DIM_SNAPSHOTS(SNAPSHOT_ID)
);

----------------
-- APPLICATIONS SCORES TABLES
----------------

DROP TABLE IF EXISTS :schema.APP_HEALTH_SCORES CASCADE;
CREATE TABLE :schema.APP_HEALTH_SCORES
(
    SNAPSHOT_ID TEXT,
    BUSINESS_CRITERION_NAME TEXT,
    IS_HEALTH_FACTOR BOOLEAN,
    NB_CRITICAL_VIOLATIONS INT,
    NB_VIOLATIONS INT,
    SCORE NUMERIC,
    CONSTRAINT APP_HEALTH_SCORES_PKEY PRIMARY KEY (SNAPSHOT_ID, BUSINESS_CRITERION_NAME),
    FOREIGN KEY (SNAPSHOT_ID) REFERENCES :schema.DIM_SNAPSHOTS(SNAPSHOT_ID)        
);

DROP TABLE IF EXISTS :schema.APP_SCORES CASCADE;
CREATE TABLE :schema.APP_SCORES
(
    SNAPSHOT_ID TEXT,
    METRIC_ID INT,
    METRIC_NAME TEXT,
    METRIC_TYPE TEXT,
    SCORE DECIMAL,
    CONSTRAINT APP_SCORES_PKEY PRIMARY KEY (SNAPSHOT_ID, METRIC_ID),
    FOREIGN KEY (SNAPSHOT_ID) REFERENCES :schema.DIM_SNAPSHOTS(SNAPSHOT_ID)
);

-----
-- APPLICATIONS EVOLUTIONS TABLES
-----

DROP TABLE IF EXISTS :schema.APP_SIZING_EVOLUTION CASCADE;
CREATE TABLE :schema.APP_SIZING_EVOLUTION
(
    SNAPSHOT_ID TEXT,
    PREVIOUS_SNAPSHOT_ID TEXT,
    NB_CRITICAL_VIOLATIONS_ADDED INT,
    NB_CRITICAL_VIOLATIONS_REMOVED INT,
    NB_VIOLATIONS_ADDED INT,
    NB_VIOLATIONS_REMOVED INT,
    TECHNICAL_DEBT_ADDED NUMERIC,
    TECHNICAL_DEBT_DELETED NUMERIC,
    CONSTRAINT APP_SIZING_EVOLUTION_PKEY PRIMARY KEY (SNAPSHOT_ID),
    FOREIGN KEY (SNAPSHOT_ID) REFERENCES :schema.DIM_SNAPSHOTS(SNAPSHOT_ID),
    FOREIGN KEY (PREVIOUS_SNAPSHOT_ID) REFERENCES :schema.DIM_SNAPSHOTS(SNAPSHOT_ID)
);

DROP TABLE IF EXISTS :schema.APP_FUNCTIONAL_SIZING_EVOLUTION CASCADE;
CREATE TABLE :schema.APP_FUNCTIONAL_SIZING_EVOLUTION
(
    SNAPSHOT_ID TEXT,
    PREVIOUS_SNAPSHOT_ID TEXT,
    NB_AEFP_DATA_FUNCTION_POINTS INT,
    NB_AEFP_IMPLEMENTATION_POINTS NUMERIC,
    NB_AEFP_POINTS_ADDED_DATA_FUNCTIONS INT,
    NB_AEFP_POINTS_ADDED_TRANSACTIONAL_FUNCTIONS INT,
    NB_AEFP_POINTS_MODIFIED_DATA_FUNCTIONS INT,
    NB_AEFP_POINTS_MODIFIED_TRANSACTIONAL_FUNCTIONS INT,
    NB_AEFP_POINTS_REMOVED_DATA_FUNCTIONS INT,
    NB_AEFP_POINTS_REMOVED_TRANSACTIONAL_FUNCTIONS INT,
    NB_AEFP_POINTS_ADDED INT,
    NB_AEFP_POINTS_REMOVED INT,
    NB_AEFP_POINTS_MODIFIED INT,
    NB_AEFP_TOTAL_POINTS INT,
    NB_AEFP_TRANSACTIONAL_FUNCTION_POINTS INT,
    NB_AEP_POINTS_ADDED_FUNCTIONS INT,
    NB_AEP_POINTS_MODIFIED_FUNCTIONS INT,
    NB_AEP_POINTS_REMOVED_FUNCTIONS INT,
    NB_AETP_POINTS_ADDED INT,
    NB_AETP_POINTS_REMOVED INT,
    NB_AETP_POINTS_MODIFIED INT,
    NB_AEP_TOTAL_POINTS INT,
    NB_AETP_IMPLEMENTATION_POINTS NUMERIC,
    NB_AETP_TOTAL_POINTS INT,
    NB_ENHANCED_SHARED_ARTIFACTS INT,
    NB_ENHANCED_SPECIFIC_ARTIFACTS INT,
    NB_EVOLVED_TRANSACTIONS INT,
    CONSTRAINT APP_FUNCTIONAL_SIZING_EVOLUTION_PKEY PRIMARY KEY (SNAPSHOT_ID),
    FOREIGN KEY (SNAPSHOT_ID) REFERENCES :schema.DIM_SNAPSHOTS(SNAPSHOT_ID),
    FOREIGN KEY (PREVIOUS_SNAPSHOT_ID) REFERENCES :schema.DIM_SNAPSHOTS(SNAPSHOT_ID)
);

DROP TABLE IF EXISTS :schema.APP_HEALTH_EVOLUTION CASCADE;
CREATE TABLE :schema.APP_HEALTH_EVOLUTION
(
    SNAPSHOT_ID TEXT,
    PREVIOUS_SNAPSHOT_ID TEXT,
    BUSINESS_CRITERION_NAME TEXT,
    IS_HEALTH_FACTOR BOOLEAN,
    NB_CRITICAL_VIOLATIONS_ADDED INT,
    NB_CRITICAL_VIOLATIONS_REMOVED INT,
    NB_VIOLATIONS_ADDED INT,
    NB_VIOLATIONS_REMOVED INT,
    CONSTRAINT APP_HEALTH_EVOLUTION_PKEY PRIMARY KEY (SNAPSHOT_ID, BUSINESS_CRITERION_NAME),
    FOREIGN KEY (SNAPSHOT_ID) REFERENCES :schema.DIM_SNAPSHOTS(SNAPSHOT_ID),
    FOREIGN KEY (PREVIOUS_SNAPSHOT_ID) REFERENCES :schema.DIM_SNAPSHOTS(SNAPSHOT_ID)    
);

----------------
-- MODULES MEASURES TABLES
----------------

DROP TABLE IF EXISTS :schema.MOD_SIZING_MEASURES CASCADE;
CREATE TABLE :schema.MOD_SIZING_MEASURES
(
    SNAPSHOT_ID TEXT,
    MODULE_NAME TEXT,
    NB_ARTIFACTS INT,
    NB_CODE_LINES INT,
    NB_COMMENT_LINES INT,
    NB_COMMENTED_OUT_CODE_LINES INT,
    NB_CRITICAL_VIOLATIONS INT,
    NB_DECISION_POINTS INT,
    NB_FILES INT,
    NB_TABLES INT,
    NB_VIOLATIONS INT,
    TECHNICAL_DEBT_DENSITY NUMERIC,
    TECHNICAL_DEBT_TOTAL NUMERIC,
    CONSTRAINT MOD_SIZING_MEASURES_PKEY PRIMARY KEY (SNAPSHOT_ID, MODULE_NAME),
    FOREIGN KEY (SNAPSHOT_ID) REFERENCES :schema.DIM_SNAPSHOTS(SNAPSHOT_ID)
);

DROP TABLE IF EXISTS :schema.MOD_VIOLATIONS_MEASURES CASCADE;
CREATE TABLE :schema.MOD_VIOLATIONS_MEASURES
(
    SNAPSHOT_ID TEXT,
    MODULE_NAME TEXT,
    RULE_ID TEXT,
    TECHNOLOGY TEXT,        
    METRIC_ID INT,
    NB_VIOLATIONS INT,
    NB_TOTAL_CHECKS INT,
    VIOLATION_RATIO NUMERIC,
    COMPLIANCE_RATIO NUMERIC,
    CONSTRAINT MOD_VIOLATIONS_MEASURE_PKEY PRIMARY KEY (SNAPSHOT_ID, MODULE_NAME, RULE_ID, TECHNOLOGY),
    FOREIGN KEY (RULE_ID) REFERENCES :schema.DIM_RULES (RULE_ID),
    FOREIGN KEY (SNAPSHOT_ID) REFERENCES :schema.DIM_SNAPSHOTS(SNAPSHOT_ID)
);

----------------
-- MODULES SCORES TABLES
----------------

DROP TABLE IF EXISTS :schema.MOD_HEALTH_SCORES CASCADE;
CREATE TABLE :schema.MOD_HEALTH_SCORES
(
    SNAPSHOT_ID TEXT,
    MODULE_NAME TEXT,    
    BUSINESS_CRITERION_NAME TEXT,
    IS_HEALTH_FACTOR BOOLEAN,
    NB_CRITICAL_VIOLATIONS INT,
    NB_VIOLATIONS INT,
    SCORE NUMERIC,
    CONSTRAINT MOD_HEALTH_SCORES_PKEY PRIMARY KEY (SNAPSHOT_ID, MODULE_NAME, BUSINESS_CRITERION_NAME),
    FOREIGN KEY (SNAPSHOT_ID) REFERENCES :schema.DIM_SNAPSHOTS(SNAPSHOT_ID)        
);

DROP TABLE IF EXISTS :schema.MOD_SCORES CASCADE;
CREATE TABLE :schema.MOD_SCORES
(
    SNAPSHOT_ID TEXT,
    MODULE_NAME TEXT,
    METRIC_ID INT,
    METRIC_NAME TEXT,
    METRIC_TYPE TEXT,
    SCORE DECIMAL,
    CONSTRAINT MOD_SCORES_PKEY PRIMARY KEY (SNAPSHOT_ID, MODULE_NAME, METRIC_ID),
    FOREIGN KEY (SNAPSHOT_ID) REFERENCES :schema.DIM_SNAPSHOTS(SNAPSHOT_ID)
);

-----
-- MODULES EVOLUTIONS TABLES
-----

DROP TABLE IF EXISTS :schema.MOD_SIZING_EVOLUTION CASCADE;
CREATE TABLE :schema.MOD_SIZING_EVOLUTION
(
    SNAPSHOT_ID TEXT,
    PREVIOUS_SNAPSHOT_ID TEXT,
    MODULE_NAME TEXT,
    NB_CRITICAL_VIOLATIONS_ADDED INT,
    NB_CRITICAL_VIOLATIONS_REMOVED INT,
    NB_VIOLATIONS_ADDED INT,
    NB_VIOLATIONS_REMOVED INT,
    TECHNICAL_DEBT_ADDED NUMERIC,
    TECHNICAL_DEBT_DELETED NUMERIC,
    CONSTRAINT MOD_SIZING_EVOLUTION_PKEY PRIMARY KEY (SNAPSHOT_ID, MODULE_NAME),
    FOREIGN KEY (SNAPSHOT_ID) REFERENCES :schema.DIM_SNAPSHOTS(SNAPSHOT_ID),
    FOREIGN KEY (PREVIOUS_SNAPSHOT_ID) REFERENCES :schema.DIM_SNAPSHOTS(SNAPSHOT_ID)
);

DROP TABLE IF EXISTS :schema.MOD_HEALTH_EVOLUTION CASCADE;
CREATE TABLE :schema.MOD_HEALTH_EVOLUTION
(
    SNAPSHOT_ID TEXT,
    PREVIOUS_SNAPSHOT_ID TEXT,
    MODULE_NAME TEXT,    
    BUSINESS_CRITERION_NAME TEXT,
    IS_HEALTH_FACTOR BOOLEAN,
    NB_CRITICAL_VIOLATIONS_ADDED INT,
    NB_CRITICAL_VIOLATIONS_REMOVED INT,
    NB_VIOLATIONS_ADDED INT,
    NB_VIOLATIONS_REMOVED INT,
    CONSTRAINT MOD_HEALTH_EVOLUTION_PKEY PRIMARY KEY (SNAPSHOT_ID, MODULE_NAME, BUSINESS_CRITERION_NAME),
    FOREIGN KEY (SNAPSHOT_ID) REFERENCES :schema.DIM_SNAPSHOTS(SNAPSHOT_ID),
    FOREIGN KEY (PREVIOUS_SNAPSHOT_ID) REFERENCES :schema.DIM_SNAPSHOTS(SNAPSHOT_ID)        
);

----------------
-- QUALITY STANDARD TABLES
----------------

DROP TABLE IF EXISTS :schema.STD_RULES CASCADE;
CREATE TABLE :schema.STD_RULES
(
    METRIC_ID INT,
    RULE_NAME TEXT,
    TAG TEXT,
    CONSTRAINT STD_RULES_PKEY PRIMARY KEY (TAG, METRIC_ID)
);

DROP TABLE IF EXISTS :schema.STD_DESCRIPTIONS CASCADE;
CREATE TABLE :schema.STD_DESCRIPTIONS
(
    STANDARD TEXT,
    CATEGORY TEXT, 
    TAG TEXT,
    TITLE TEXT,
    CONSTRAINT STD_DESCRIPTIONS_PKEY PRIMARY KEY (STANDARD, CATEGORY, TAG)
);

----------------
-- ED TABLES
----------------

DROP TABLE IF EXISTS :schema.SRC_OBJECTS CASCADE;
CREATE TABLE :schema.SRC_OBJECTS
(
    APPLICATION_NAME TEXT,
    OBJECT_ID TEXT,
    OBJECT_NAME TEXT,
    OBJECT_FULL_NAME TEXT,
    TECHNOLOGY TEXT,
    OBJECT_STATUS TEXT,
    ACTION_PLANNED BOOLEAN,
    IS_ARTIFACT BOOLEAN,
    COST_COMPLEXITY INT,
    CONSTRAINT SRC_OBJECTS_PKEY PRIMARY KEY (OBJECT_ID)
);
DROP INDEX IF EXISTS :schema.SRC_OBJECTS_IDX;
CREATE INDEX SRC_OBJECTS_IDX ON :schema.SRC_OBJECTS USING btree(APPLICATION_NAME, OBJECT_ID);

DROP TABLE IF EXISTS :schema.SRC_MOD_OBJECTS CASCADE;
CREATE TABLE :schema.SRC_MOD_OBJECTS
(
    APPLICATION_NAME TEXT,
    MODULE_NAME TEXT,
    OBJECT_ID TEXT
);
DROP INDEX IF EXISTS :schema.SRC_MOD_OBJECTS_IDX;
CREATE INDEX SRC_MOD_OBJECTS_IDX ON :schema.SRC_MOD_OBJECTS USING btree(APPLICATION_NAME, MODULE_NAME, OBJECT_ID);
CREATE INDEX SRC_MOD_OBJECTS_IDX2 ON :schema.SRC_MOD_OBJECTS USING btree(MODULE_NAME, OBJECT_ID);

DROP TABLE IF EXISTS :schema.SRC_TRANSACTIONS CASCADE;
CREATE TABLE :schema.SRC_TRANSACTIONS
(
    APPLICATION_NAME TEXT,
    TRX_ID TEXT,
    TRX_NAME TEXT,
    TRX_FULL_NAME TEXT,
    TRX_STATUS TEXT,
    CONSTRAINT SRC_TRANSACTIONS_PKEY PRIMARY KEY (TRX_ID)
);
DROP INDEX IF EXISTS :schema.SRC_TRANSACTIONS_IDX;
CREATE INDEX SRC_TRANSACTIONS_IDX ON :schema.SRC_TRANSACTIONS USING btree(APPLICATION_NAME, TRX_ID);

DROP TABLE IF EXISTS :schema.SRC_TRX_OBJECTS CASCADE;
CREATE TABLE :schema.SRC_TRX_OBJECTS
(
    TRX_ID TEXT,
    OBJECT_ID TEXT
);

DROP TABLE IF EXISTS :schema.SRC_VIOLATIONS CASCADE;
CREATE TABLE :schema.SRC_VIOLATIONS
(
    SNAPSHOT_ID TEXT,
    RULE_ID TEXT,
    METRIC_ID INT,
    RULE_NAME TEXT,
    OBJECT_ID TEXT,
    FINDING_NAME TEXT,
    FINDING_TYPE TEXT,
    NB_FINDINGS INT,
    CONSTRAINT SRC_VIOLATIONS_PKEY PRIMARY KEY (RULE_ID, OBJECT_ID, SNAPSHOT_ID)
);

DROP TABLE IF EXISTS :schema.SRC_HEALTH_IMPACTS CASCADE;
CREATE TABLE :schema.SRC_HEALTH_IMPACTS
(
    OBJECT_ID TEXT,	
    OBJECT_NAME TEXT,
    BUSINESS_CRITERION_NAME TEXT,
    PROPAGATED_RISK_INDEX NUMERIC,
    RISK_PROPAGATION_FACTOR NUMERIC,
    
    CONSTRAINT SRC_HEALTH_IMPACTS_PKEY PRIMARY KEY (OBJECT_ID, BUSINESS_CRITERION_NAME)
);

DROP TABLE IF EXISTS :schema.USR_EXCLUSIONS CASCADE;
CREATE TABLE :schema.USR_EXCLUSIONS
(
    APPLICATION_NAME TEXT,
    RULE_ID TEXT,
    RULE_NAME TEXT,
    OBJECT_ID TEXT,
    OBJECT_NAME TEXT,
    USER_NAME TEXT,
    COMMENT TEXT,
    CONSTRAINT USR_EXCLUSIONS_PKEY PRIMARY KEY (RULE_ID, OBJECT_ID)
);
DROP INDEX IF EXISTS :schema.USR_EXCLUSIONS_IDX;
CREATE INDEX USR_EXCLUSIONS_IDX ON :schema.USR_EXCLUSIONS USING btree(APPLICATION_NAME, OBJECT_ID, RULE_ID);

DROP TABLE IF EXISTS :schema.USR_ACTION_PLAN CASCADE;
CREATE TABLE :schema.USR_ACTION_PLAN
(
    APPLICATION_NAME TEXT,
    RULE_ID TEXT,
    RULE_NAME TEXT,
    OBJECT_ID TEXT,
    OBJECT_NAME TEXT,
    ACTION_STATUS TEXT,
    LAST_UPDATE_DATE DATE,
    START_DATE DATE,
    END_DATE DATE,
    USER_NAME TEXT,
    COMMENT TEXT,
    PRIORITY TEXT,
    TAG TEXT,
    CONSTRAINT USR_ACTION_PLAN_PKEY PRIMARY KEY (RULE_ID, OBJECT_ID, START_DATE)
);
DROP INDEX IF EXISTS :schema.USR_ACTION_PLAN_IDX;
CREATE INDEX USR_ACTION_PLAN_IDX ON :schema.USR_ACTION_PLAN USING btree(APPLICATION_NAME, OBJECT_ID, RULE_ID);