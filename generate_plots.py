import matplotlib.pyplot as plt
import numpy as np
import os

plt.rcParams.update({'font.size': 12, 'figure.autolayout': True})

def plot_freefall():
    if not os.path.exists('results/test1_freefall.dat'): return
    data = np.loadtxt('results/test1_freefall.dat')
    plt.figure(figsize=(6, 4))
    plt.plot(data[:, 0], data[:, 1], 'b-', label='Numerical')
    plt.plot(data[:, 0], data[:, 2], 'r--', label='Analytical')
    plt.xlabel('Time (s)')
    plt.ylabel('Height (m)')
    plt.title('Verification: Free Fall')
    plt.legend()
    plt.grid(True, linestyle='--')
    plt.savefig('plots/test1_freefall.png', dpi=300)
    plt.close()

def plot_velocity():
    if not os.path.exists('results/test2_velocity.dat'): return
    data = np.loadtxt('results/test2_velocity.dat')
    plt.figure(figsize=(6, 4))
    plt.plot(data[:, 0], data[:, 1], 'k-')
    plt.ylim(0, 2)
    plt.xlabel('Time (s)')
    plt.ylabel('Velocity (m/s)')
    plt.title('Verification: Constant Velocity')
    plt.grid(True, linestyle='--')
    plt.savefig('plots/test2_velocity.png', dpi=300)
    plt.close()

def plot_bounce():
    if not os.path.exists('results/test3_bounce.dat'): return
    data = np.loadtxt('results/test3_bounce.dat')
    plt.figure(figsize=(6, 4))
    plt.plot(data[:, 0], data[:, 1], 'g-')
    plt.xlabel('Time (s)')
    plt.ylabel('Height (m)')
    plt.title('Verification: Particle Bounce')
    plt.grid(True, linestyle='--')
    plt.savefig('plots/test3_bounce.png', dpi=300)
    plt.close()

if __name__ == "__main__":
    plot_freefall()
    plot_velocity()
    plot_bounce()
    print("All verification plots generated in /plots")
