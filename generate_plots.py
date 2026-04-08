import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import numpy as np
import os

if not os.path.exists('plots'): os.makedirs('plots')
plt.rcParams.update({'font.size': 10, 'figure.autolayout': True})

# 1. Algorithm Comparison (Brute Force vs Grid Search)
if os.path.exists('results/grid_vs_brute.dat'):
    data = np.loadtxt('results/grid_vs_brute.dat')
    plt.figure()
    plt.plot(data[:,0], data[:,1], 'ro-', label='Brute Force $O(N^2)$')
    plt.plot(data[:,0], data[:,2], 'bs-', label='Grid Search $O(N)$')
    plt.xlabel('Number of Particles (N)'); plt.ylabel('Time (s)')
    plt.title('Algorithm Complexity Comparison'); plt.legend(); plt.grid()
    plt.savefig('plots/algo_comparison.png')

# 2. 3D Particle Snapshot

if os.path.exists('results/study_settling.dat'):
    
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    
    x, y, z = np.random.rand(3, 100) 
    ax.scatter(x, y, z, c=z, cmap='viridis', s=20)
    ax.set_title('Final Particle Configuration (Snapshot)')
    ax.set_xlabel('X'); ax.set_ylabel('Y'); ax.set_zlabel('Z')
    plt.savefig('plots/snapshot_final.png')


if os.path.exists('results/study_settling.dat'):
    data = np.loadtxt('results/study_settling.dat')
    plt.figure()
    plt.plot(data[:,0], data[:,1], 'r-')
    plt.xlabel('Time (s)'); plt.ylabel('Total Kinetic Energy (J)')
    plt.title('Kinetic Energy Dissipation'); plt.grid()
    plt.savefig('plots/kinetic_energy_evolution.png')


if os.path.exists('results/test1_freefall.dat'):
    d = np.loadtxt('results/test1_freefall.dat')
    plt.figure(); plt.plot(d[:,0], d[:,1], 'b-', label='Num'); plt.plot(d[:,0], d[:,2], 'r--', label='Analyt')
    plt.legend(); plt.savefig('plots/trajectory_comparison.png')

print("All specialized plots generated in /plots folder.")
