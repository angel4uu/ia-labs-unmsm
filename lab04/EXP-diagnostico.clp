(deftemplate sintoma
    (slot nombre (type SYMBOL))
)

(deftemplate enfermedad
    (slot nombre (type SYMBOL))
    (slot recomendacion (type STRING))
)

(defrule dengue
    (sintoma (nombre fiebre))
    (sintoma (nombre dolor_cabeza))
    (sintoma (nombre dolor_muscular))
    =>
    (assert (enfermedad (nombre dengue)
                        (recomendacion "Tomar paracetamol, hidratarse y evitar antiinflamatorios."))
    )
)

(defrule Covid-19
    (sintoma (nombre fiebre))
    (sintoma (nombre tos))
    (sintoma (nombre perdida_olfato))
    (sintoma (nombre perdida_gusto))
    =>
    (assert (enfermedad (nombre COVID-19)
                        (recomendacion "Aislamiento inmediato, prueba PCR y consultar médico."))
    )
)

(defrule Alergia
    (sintoma (nombre estornudos))
    (sintoma (nombre ojos_rojos))
    (not (sintoma (nombre fiebre)))
    =>
    (assert (enfermedad (nombre alergia)
                        (recomendacion "Tomar cetirizina, hidratarse y si los sintomas persisten consultar médico."))
    )
)

(defrule Gripe
    (sintoma (nombre fiebre))
    (sintoma (nombre tos))
    (sintoma (nombre congestion_nasal))
    (not (sintoma (nombre perdida_olfato))) ; Diferenciador clave del COVID-19
    (not (enfermedad (nombre COVID-19)))    ; Prioridad a COVID-19 si está presente
    =>
    (assert (enfermedad (nombre gripe)
                        (recomendacion "Reposo, líquidos abundantes y antigripales comunes. Consultar si la fiebre persiste más de 3 días."))
    )
)

(deffunction capturar-sintomas ()
  (printout t "Síntomas disponibles: fiebre, tos, perdida_olfato, perdida_gusto, estornudos, ojos_rojos, dolor_cabeza, dolor_muscular, congestion_nasal" crlf)
  (bind ?sintoma (read))
  (while (neq (str-compare ?sintoma "fin") 0)
    (assert (sintoma (nombre ?sintoma)))
    (printout t "✔ Síntoma capturado: " ?sintoma crlf)
    (bind ?sintoma (read))
  )
  (printout t "✔ Entrada de síntomas finalizada." crlf)
)

(deffunction ejecutar-diagnostico ()
  (run)
)

(deffunction mostrar-diagnostico ()
  (printout t "*** Diagnóstico(s) generado(s):" crlf)
  (do-for-all-facts ((?e enfermedad)) TRUE
    (printout t "→ " (fact-slot-value ?e nombre) ": " (fact-slot-value ?e recomendacion) crlf)
  )
)

(deffunction iniciar-diagnostico ()
  (capturar-sintomas)
  (ejecutar-diagnostico)
  (mostrar-diagnostico)
)
