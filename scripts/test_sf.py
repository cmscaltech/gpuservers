import strawberryfields as sf
from strawberryfields.ops import Vgate
import numpy as np
import tensorflow as tf
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

eng = sf.Engine(backend="tf", backend_options={"cutoff_dim": 10})
circuit = sf.Program(1)

N = 5


target_fock = 3 #targeted fock state

tf_gammas = tf.Variable(tf.random.normal(shape = [N])) 
gammas = []
for i in range(N):
    gammas.append( circuit.params("gamma{}".format(i)))
gammas = np.array(gammas)

with circuit.context as q:
     for i in range(N):
         Vgate(gammas[i]) | q
         
opt = tf.keras.optimizers.Adam(learning_rate=0.1)
steps = 100

losses=[]
params_hist=[]
for step in range(steps):
    if eng.run_progs:
        eng.reset()

    with tf.GradientTape() as tape:
        tape.watch(tf_gammas)
        mapping = {p.name:w for p,w in zip(gammas,tf_gammas)}
        results = eng.run(circuit, args=mapping)
        prob = results.state.fock_prob([target_fock])
        loss = -prob

    gradients = tape.gradient(loss, tf_gammas)
    opt.apply_gradients(zip([gradients], [tf_gammas]))
    losses.append( loss )
    params_hist.append( np.array(tf_gammas) )
    print("Step: {}, loss; {}, gammas: {}".format(step, losses[-1], params_hist[-1]))
