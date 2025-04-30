import clips

env = clips.Environment()

env.load("EXP-diagnostico.clp")

env.reset()

env.call("iniciar-diagnostico")