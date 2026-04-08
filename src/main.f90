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

    allocate(p(1))
    p(1)%x = [0.5_8, 0.5_8, 1.0_8]; p(1)%v = 0.0_8; p(1)%mass = 1.0_8; p(1)%radius = 0.05_8
    open(unit=10, file='results/test3_bounce.dat')
    do step = 1, 5000
        p(1)%f = 0.0_8; p(1)%f(3) = p(1)%f(3) + p(1)%mass * G
        if (p(1)%radius - p(1)%x(3) > 0.0_8) then
            p(1)%f(3) = p(1)%f(3) + KN*(p(1)%radius - p(1)%x(3)) - GAMMA_N*p(1)%v(3)
        end if
        p(1)%v = p(1)%v + (p(1)%f / p(1)%mass) * DT
        p(1)%x = p(1)%x + p(1)%v * DT
        write(10, *) step*DT, p(1)%x(3)
    end do
    close(10)
    deallocate(p)

    ! 2. DAMPING STUDY
    open(unit=20, file='results/study_damping.dat')
    do i = 1, 3
        allocate(p(1))
        p(1)%x = [0.5_8, 0.5_8, 1.0_8]; p(1)%v = 0.0_8; p(1)%mass = 1.0_8; p(1)%radius = 0.05_8
        do step = 1, 5000
            p(1)%f = 0.0_8; p(1)%f(3) = p(1)%f(3) + p(1)%mass * G
            if (p(1)%radius - p(1)%x(3) > 0.0_8) then
                p(1)%f(3) = p(1)%f(3) + KN*(p(1)%radius - p(1)%x(3)) - gammas(i)*p(1)%v(3)
            end if
            p(1)%v = p(1)%v + (p(1)%f / p(1)%mass) * DT
            p(1)%x = p(1)%x + p(1)%v * DT
            if (mod(step, 10) == 0) write(20, *) step*DT, p(1)%x(3), gammas(i)
        end do
        deallocate(p)
    end do
    close(20)

    !  SEttling CLOUD DATA
    n_p = 100
    allocate(p(n_p))
    call init_grid([1.0_8, 1.0_8, 1.0_8], 0.03_8)
    call random_seed()
    do i = 1, n_p
        call random_number(p(i)%x); p(i)%x = p(i)%x * 0.7_8 + 0.1_8
        p(i)%v = 0.0_8; p(i)%mass = 1.0_8; p(i)%radius = 0.01_8
    end do
    open(unit=30, file='results/study_settling.dat')
    do step = 1, 5000
        call zero_forces(p); call add_gravity(p); call wall_forces(p)
        call particle_contacts_grid(p); call integrate_particles(p)
        if (mod(step, 50) == 0) then
            ke = compute_kinetic_energy(p)
            write(30, *) step*DT, ke
        end if
    end do
    close(30)
    print *, "All study data generated."
end program main
