program main
    use types
    use params
    use physics
    use io_utils
    implicit none
    type(Particle), allocatable :: p(:)
    integer :: i, step, n_particles
    real(8) :: t_start, t_end
    integer, dimension(3) :: counts = [200, 1000, 5000]
    integer :: c

    open(unit=40, file='results/scaling_results.dat')
    write(40, *) "# N_Particles  Runtime(s)"

    do c = 1, 3
        n_particles = counts(c)
        if (allocated(p)) deallocate(p)
        allocate(p(n_particles))
        
        ! Initialize particles randomly in the box
        call random_seed()
        do i = 1, n_particles
            call random_number(p(i)%x)
            p(i)%x = p(i)%x * 0.8_8 + 0.1_8
            p(i)%v = 0.0_8
            p(i)%mass = 1.0_8
            p(i)%radius = 0.01_8
        end do

        print *, "Starting simulation for N =", n_particles
        call cpu_time(t_start)
        
        ! Run for a fixed number of steps for profiling
        do step = 1, 500
            call zero_forces(p)
            call add_gravity(p)
            call wall_forces(p)
            call particle_contacts(p)
            call integrate_particles(p)
        end do
        
        call cpu_time(t_end)
        write(40, *) n_particles, t_end - t_start
        print *, "N =", n_particles, " took ", t_end - t_start, " seconds"
    end do
    
    close(40)
end program main
