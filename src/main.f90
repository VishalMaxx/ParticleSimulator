program main
    use types
    use params
    use physics
    use grid_search
    use io_utils
    implicit none
    type(Particle), allocatable :: p(:)
    integer :: step, i, n_p
    real(8) :: ke, com_h, current_dt
    real(8) :: gammas(3) = [10.0_8, 50.0_8, 100.0_8]
    real(8) :: dts(3) = [1.0d-3, 5.0d-4, 1.0d-4]

    open(unit=100, file='results/study_damping.dat')
    do i = 1, 3
        if (allocated(p)) deallocate(p)
        allocate(p(1))
        p(1)%x = [0.5_8, 0.5_8, 1.0_8]
        p(1)%v = 0.0_8
        p(1)%mass = 1.0_8
        p(1)%radius = 0.05_8
        do step = 1, 20000
            p(1)%f = 0.0_8
            p(1)%f(3) = p(1)%f(3) + p(1)%mass * G
            if (p(1)%radius - p(1)%x(3) > 0.0_8) then
                p(1)%f(3) = p(1)%f(3) + KN*(p(1)%radius - p(1)%x(3)) - gammas(i)*p(1)%v(3)
            end if
            p(1)%v = p(1)%v + (p(1)%f / p(1)%mass) * DT
            p(1)%x = p(1)%x + p(1)%v * DT
            if (mod(step, 50) == 0) write(100, *) step*DT, p(1)%x(3), gammas(i)
        end do
    end do
    close(100)

    open(unit=101, file='results/study_timestep.dat')
    do i = 1, 3
        current_dt = dts(i)
        if (allocated(p)) deallocate(p)
        allocate(p(1))
        p(1)%x = [0.0_8, 0.0_8, 10.0_8]
        p(1)%v = 0.0_8
        p(1)%mass = 1.0_8
        p(1)%radius = 0.05_8
        do step = 1, int(1.0_8 / current_dt)
            p(1)%f = 0.0_8
            p(1)%f(3) = p(1)%f(3) + p(1)%mass * G
            p(1)%v = p(1)%v + (p(1)%f / p(1)%mass) * current_dt
            p(1)%x = p(1)%x + p(1)%v * current_dt
            if (mod(step, 10) == 0) write(101, *) step*current_dt, p(1)%x(3), current_dt
        end do
    end do
    close(101)

    n_p = 100
    if (allocated(p)) deallocate(p)
    allocate(p(n_p))
    call init_grid([1.0_8, 1.0_8, 1.0_8], 0.03_8)
    call random_seed()
    do i = 1, n_p
        call random_number(p(i)%x)
        p(i)%x = p(i)%x * 0.7_8 + 0.1_8
        p(i)%v = 0.0_8
        p(i)%mass = 1.0_8
        p(i)%radius = 0.01_8
    end do
    open(unit=102, file='results/study_settling.dat')
    do step = 1, 10000
        call zero_forces(p)
        call add_gravity(p)
        call wall_forces(p)
        call particle_contacts_grid(p)
        call integrate_particles(p)
        if (mod(step, 100) == 0) then
            ke = compute_kinetic_energy(p)
            com_h = sum(p%x(3)) / n_p
            write(102, *) step*DT, com_h, ke
        end if
    end do
    close(102)
end program main
