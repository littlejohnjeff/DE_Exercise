SELECT 
  p.patientid AS patient_id
, p.Sex
--probably pulling current age, whereas age at med order/admission/encounter might be more appropriate
, p.Age
--pulling current PCP, why not PCP at time of order/encounter - or the ordering provider
, ISNULL(p.primary_care_provider,'No Current PCP') AS primary_care_provider
--some meds (primarily IV) without simple generic name, these also lacked RXNorm/NDC
, ISNULL(m.medication_simple_generic_name,'No Med Simple Generic Name') AS medication_simple_generic_name
, AVG(CAST(m.minimum_dose AS NUMERIC(18,2))) AS avg_minimum_dose
, m.dose_unit
, e.admit_diagnosis
--validation count
--, COUNT(m.medicationorderid) AS MED_ORDER_COUNT
FROM TendoExercise.dbo.patients p
JOIN TendoExercise.dbo.medicationorders m 
	ON m.patientid = p.patientid
JOIN TendoExercise.dbo.encounters e
	ON e.patientid = m.patientid
		AND e.encounterid = m.encounterid
GROUP BY
  p.patientid 
, p.Sex
, p.Age
, p.primary_care_provider
, m.medication_simple_generic_name
, m.dose_unit
, e.admit_diagnosis