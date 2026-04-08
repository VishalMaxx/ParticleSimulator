import matplotlib.pyplot as plt
import numpy as np
import os

plt.rcParams.update({'font.size': 12})

def plot_all():
    # 1 and 2- Free Fall Trajectory + Analytical
    if os.path.exists('results/test1_freefall.dat'):
        d = np.loadtxt('results/test1_freefall.dat')
        plt.figure()
        plt.plot(d[:,0], d[:,1], 'b-', label='Numerical')
        plt.plot(d[:,0], d[:,2], 'r--', label='Analytical')
        plt.xlabel('Time (s)'); plt.ylabel('Z (m)'); plt.legend(); plt.grid()
        plt.savefig('plots/trajectory_comparison.png')

    # 3: Error vsTimestep
    if os.path.exists('results/error_study.dat'):
        d = np.loadtxt('results/error_study.dat')
        plt.figure()
        plt.loglog(d[:,0], d[:,1], 'ko-')
        plt.xlabel('Timestep (s)'); plt.ylabel('Final Error (m)'); plt.grid()
        plt.savefig('plots/error_vs_dt.png')

    # 4: Bouncing Height
    if os.path.exists('results/test3_bounce.dat'):
        d = np.loadtxt('results/test3_bounce.dat')
        plt.figure()
        plt.plot(d[:,0], d[:,1], 'g-')
        plt.xlabel('Time (s)'); plt.ylabel('Height (m)'); plt.grid()
        plt.savefig('plots/bouncing_height.png')

    # 5: Kinetic Energy vs Time
    if os.path.exists('results/ke_time.dat'):
        d = np.loadtxt('results/ke_time.dat')
        plt.figure()
        plt.plot(d[:,0], d[:,1], 'r-')
        plt.xlabel('Time (s)'); plt.ylabel('Kinetic Energy (J)'); plt.grid()
        plt.savefig('plots/kinetic_energy.png')

    # 6: Snapshot 
    if os.path.exists('results/snap_005000.dat'):
        d = np.loadtxt('results/snap_005000.dat')
        plt.figure(figsize=(5,5))
        plt.scatter(d[:,0], d[:,2], s=50, edgecolors='k', alpha=0.7)
        plt.xlim(0,1); plt.ylim(0,1)
        plt.xlabel('X (m)'); plt.ylabel('Z (m)'); plt.title('Particle Snapshot')
        plt.savefig('plots/snapshot_final.png')

if __name__ == "__main__":
    plot_all()
    print("All 6 required plots generated in /plots")
def plot_parallel_scaling():
    if not os.path.exists('results/parallel_scaling.dat'): return
    data = np.loadtxt('results/parallel_scaling.dat')
    threads = data[:, 0]
    times = data[:, 1]
    t1 = times[0]
    speedup = t1 / times
    efficiency = speedup / threads

    plt.figure()
    plt.plot(threads, speedup, 'bo-', label='Measured Speedup')
    plt.plot(threads, threads, 'r--', label='Ideal Speedup')
    plt.xlabel('Threads'); plt.ylabel('Speedup S(p)'); plt.legend(); plt.grid()
    plt.savefig('plots/speedup.png')

    plt.figure()
    plt.plot(threads, efficiency, 'go-')
    plt.xlabel('Threads'); plt.ylabel('Efficiency E(p)'); plt.ylim(0, 1.1); plt.grid()
    plt.savefig('plots/efficiency.png')
def plot_strong_scaling():
    if not os.path.exists('results/strong_scaling.dat'): return
    data = np.loadtxt('results/strong_scaling.dat')
    p = data[:, 0]
    t_p = data[:, 1]
    t_1 = t_p[0]
    
    speedup = t_1 / t_p
    efficiency = speedup / p

    # Speedup Plot
    plt.figure()
    plt.plot(p, speedup, 'bo-', label='Measured Speedup')
    plt.plot(p, p, 'r--', label='Ideal Speedup')
    plt.xlabel('Number of Threads (p)')
    plt.ylabel('Speedup S(p)')
    plt.title('Strong Scaling: Speedup')
    plt.legend(); plt.grid()
    plt.savefig('plots/strong_scaling_speedup.png')

    # Efficiency Plot
    plt.figure()
    plt.plot(p, efficiency, 'go-', label='Parallel Efficiency')
    plt.axhline(y=1.0, color='r', linestyle='--')
    plt.xlabel('Number of Threads (p)')
    plt.ylabel('Efficiency E(p)')
    plt.title('Strong Scaling: Efficiency')
    plt.ylim(0, 1.1); plt.grid()
    plt.savefig('plots/strong_scaling_efficiency.png')


