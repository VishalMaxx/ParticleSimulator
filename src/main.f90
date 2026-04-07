program main
    use types
    use params
    use physics
    use io_utils
    implicit none
    type(Particle), allocatable :: p(:)
    integer :: i, step, n_particles
    real(8) :: t_start, t_end, ke
    n_particles = 200
    allocate(p(n_particles))
    call random_seed()
    do i = 1, n_particles
        call random_number(p(i)%x)
        p(i)%x = p(i)%x * 0.8_8 + 0.1_8
        p(i)%v = 0.0_8
        p(i)%mass = 1.0_8
        p(i)%radius = 0.02_8
    end do
    open(unit=20, file='results/energy.dat')
    call cpu_time(t_start)
    do step = 1, 5000
        call zero_forces(p)
        call add_gravity(p)
        call wall_forces(p)
        call particle_contacts(p)
        call integrate_particles(p)
        if (mod(step, 100) == 0) then
            ke = compute_kinetic_energy(p)
            write(20, *) step*DT, ke
            call save_snapshot(p, step)
        end if
    end do
    call cpu_time(t_end)
    print *, "Total Simulation Time:", t_end - t_start, "seconds"
    close(20)
end program main
