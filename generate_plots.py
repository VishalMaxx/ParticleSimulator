import matplotlib.pyplot as plt
import numpy as np
import os

plt.rcParams.update({'font.size': 11, 'figure.autolayout': True})

def scientific_plots():
    # 1. Damping Investigation
    if os.path.exists('results/study_damping.dat'):
        data = np.loadtxt('results/study_damping.dat')
        plt.figure()
        for g in [10.0, 50.0, 100.0]:
            subset = data[data[:, 2] == g]
            plt.plot(subset[:, 0], subset[:, 1], label=f'Gamma={g}')
        plt.xlabel('Time (s)'); plt.ylabel('Height (m)'); plt.legend(); plt.grid()
        plt.savefig('plots/investigation_damping_height.png')

    # 2. Timestep Sensitivity
    if os.path.exists('results/study_timestep.dat'):
        data = np.loadtxt('results/study_timestep.dat')
        plt.figure()
        for dt in [1.0e-3, 5.0e-4, 1.0e-4]:
            subset = data[data[:, 2] == dt]
            plt.plot(subset[:, 0], subset[:, 1], label=f'dt={dt}')
        plt.xlabel('Time (s)'); plt.ylabel('Height (m)'); plt.legend(); plt.grid()
        plt.savefig('plots/investigation_timestep_stability.png')

    # 3. Particle Cloud Settling
    if os.path.exists('results/study_settling.dat'):
        data = np.loadtxt('results/study_settling.dat')
        # Center of Mass Plot
        plt.figure()
        plt.plot(data[:, 0], data[:, 1], 'b-')
        plt.xlabel('Time (s)'); plt.ylabel('Center of Mass Height (m)'); plt.grid()
        plt.savefig('plots/investigation_settling_com.png')
        # Kinetic Energy Plot
        plt.figure()
        plt.plot(data[:, 0], data[:, 2], 'r-')
        plt.xlabel('Time (s)'); plt.ylabel('Total Kinetic Energy (J)'); plt.grid()
        plt.savefig('plots/investigation_settling_ke.png')

if __name__ == "__main__":
    scientific_plots()
    print("All scientific investigation plots generated.")
