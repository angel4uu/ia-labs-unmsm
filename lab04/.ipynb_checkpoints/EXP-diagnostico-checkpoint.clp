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
    (not (sintoma (nombre sangrado_encias)))
    (not (sintoma (nombre sangrado_nariz)))
    (not (enfermedad (nombre dengue-grave)))
    =>
    (assert (enfermedad (nombre dengue)
                        (recomendacion "Tomar paracetamol, hidratarse y evitar antiinflamatorios."))
    )
)

(defrule dengue-grave
    (sintoma (nombre fiebre))
    (sintoma (nombre dolor_cabeza))
    (sintoma (nombre sangrado_encias))
    (sintoma (nombre sangrado_nariz))
    =>
    (assert (enfermedad (nombre dengue_grave)
                        (recomendacion "Atención medica urgente. Hidratarse, evitar medicación sin receta, y acudir al hospital inmediatamente."))
    )
)

(defrule Covid-19
    (sintoma (nombre fiebre))
    (sintoma (nombre tos))
    (sintoma (nombre perdida_olfato))
    (sintoma (nombre perdida_gusto))
    (sintoma (nombre dificultad_respirar))
    =>
    (assert (enfermedad (nombre COVID-19)
                        (recomendacion "Aislamiento inmediato, prueba PCR y consultar medico."))
    )
)

(defrule Alergia
    (sintoma (nombre estornudos))
    (sintoma (nombre ojos_rojos))
    (not (sintoma (nombre fiebre)))
    =>
    (assert (enfermedad (nombre alergia)
                        (recomendacion "Tomar cetirizina, hidratarse y si los sintomas persisten consultar medico."))
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
                        (recomendacion "Reposo, liquidos abundantes y antigripales comunes. Consultar si la fiebre persiste más de 3 dias."))
    )
)

(deffunction capturar-sintomas ()
    (printout t "Sintomas disponibles:" crlf)
    (printout t "fiebre, tos, perdida_olfato, perdida_gusto, estornudos, ojos_rojos," crlf)
    (printout t "dolor_cabeza, dolor_muscular, congestion_nasal, dificultad_respirar," crlf)
    (printout t "sangrado_encias, sangrado_nariz" crlf)
    (bind ?sintoma (read))
    (while (neq (str-compare ?sintoma "fin") 0)
        (assert (sintoma (nombre ?sintoma)))
        (printout t "-> Sintoma capturado: " ?sintoma crlf)
        (bind ?sintoma (read))
    )
    (printout t "-> Entrada de sintomas finalizada." crlf)
)

(deffunction ejecutar-diagnostico ()
  (run)
)

(deffunction mostrar-diagnostico ()
  (printout t "*** Diagnostico(s) generado(s):" crlf)
  (do-for-all-facts ((?e enfermedad)) TRUE
    (printout t "-> " (fact-slot-value ?e nombre) ": " (fact-slot-value ?e recomendacion) crlf)
  )
)

(deffunction iniciar-diagnostico ()
  (capturar-sintomas)
  (ejecutar-diagnostico)
  (mostrar-diagnostico)
)
