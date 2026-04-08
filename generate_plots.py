import matplotlib.pyplot as plt
import numpy as np
import os

plt.rcParams.update({'font.size': 11, 'figure.autolayout': True})

def plot_verification():
    # Free Fall
    if os.path.exists('results/test1_freefall.dat'):
        d = np.loadtxt('results/test1_freefall.dat')
        plt.figure()
        plt.plot(d[:,0], d[:,1], 'b-', label='Numerical')
        plt.plot(d[:,0], d[:,2], 'r--', label='Analytical')
        plt.xlabel('Time (s)'); plt.ylabel('Z (m)'); plt.legend(); plt.grid()
        plt.savefig('plots/trajectory_comparison.png')
    # Error vs Timestep
    if os.path.exists('results/error_study.dat'):
        d = np.loadtxt('results/error_study.dat')
        plt.figure()
        plt.loglog(d[:,0], d[:,1], 'ko-')
        plt.xlabel('Timestep (s)'); plt.ylabel('Final Error (m)'); plt.grid()
        plt.savefig('plots/error_vs_dt.png')

def plot_strong_scaling():
    if not os.path.exists('results/strong_scaling.dat'): 
        print("Missing strong_scaling.dat")
        return
    data = np.loadtxt('results/strong_scaling.dat')
    p = data[:, 0]
    t_p = data[:, 1]
    t_1 = t_p[0]
    speedup = t_1 / t_p
    efficiency = speedup / p

    plt.figure()
    plt.plot(p, speedup, 'bo-', label='Measured Speedup')
    plt.plot(p, p, 'r--', label='Ideal Speedup')
    plt.xlabel('Threads'); plt.ylabel('Speedup S(p)'); plt.legend(); plt.grid()
    plt.savefig('plots/strong_scaling_speedup.png')

    plt.figure()
    plt.plot(p, efficiency, 'go-')
    plt.axhline(y=1.0, color='r', linestyle='--')
    plt.xlabel('Threads'); plt.ylabel('Efficiency E(p)'); plt.ylim(0, 1.1); plt.grid()
    plt.savefig('plots/strong_scaling_efficiency.png')

def scientific_plots():
    if os.path.exists('results/study_damping.dat'):
        data = np.loadtxt('results/study_damping.dat')
        plt.figure()
        plt.plot(data[:, 0], data[:, 1], 'm-')
        plt.xlabel('Time (s)'); plt.ylabel('Height (m)'); plt.grid()
        plt.savefig('plots/investigation_damping_height.png')

if __name__ == "__main__":
    if not os.path.exists('plots'): os.makedirs('plots')
    plot_verification()
    plot_strong_scaling()
    scientific_plots()
    print("All plots generated successfully.")
