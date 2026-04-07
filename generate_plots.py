import matplotlib.pyplot as plt
import numpy as np
import os

# Set global font size for publication quality
plt.rcParams.update({'font.size': 12})

def plot_freefall():
    if not os.path.exists('results/test1_freefall.dat'): return
    data = np.loadtxt('results/test1_freefall.dat')
    plt.figure(figsize=(8, 5))
    plt.plot(data[:, 0], data[:, 1], 'b-', label='Numerical')
    plt.plot(data[:, 0], data[:, 2], 'r--', label='Analytical')
    plt.xlabel('Time (s)')
    plt.ylabel('Height (m)')
    plt.title('Free Fall Verification')
    plt.legend()
    plt.grid(True)
    plt.savefig('plots/verification_freefall.png', dpi=300)
    plt.close()

def plot_bounce():
    if not os.path.exists('results/test3_bounce.dat'): return
    data = np.loadtxt('results/test3_bounce.dat')
    plt.figure(figsize=(8, 5))
    plt.plot(data[:, 0], data[:, 1], 'g-')
    plt.xlabel('Time (s)')
    plt.ylabel('Height (m)')
    plt.title('Single Particle Bounce')
    plt.grid(True)
    plt.savefig('plots/verification_bounce.png', dpi=300)
    plt.close()

if __name__ == "__main__":
    plot_freefall()
    plot_bounce()
    print("Plots generated in plots/ directory.")
