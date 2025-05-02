import clips

env = clips.Environment()
env.load("EXP-diagnostico.clp")
env.reset()

# Añadir esta línea para ver las reglas disponibles
print("Reglas disponibles:")
for rule in env.rules():
    print(rule)

env.call("iniciar-diagnostico")