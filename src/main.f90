program main
    use types
    use params
    use physics
    use io_utils
    implicit none
    type(Particle), allocatable :: p(:)
    integer :: i, step, n_p
    real(8) :: ke
    n_p = 100
    allocate(p(n_p))
    call random_seed()
    do i = 1, n_p
        call random_number(p(i)%x)
        p(i)%x = p(i)%x * 0.7_8 + 0.1_8
        p(i)%v = 0.0_8
        p(i)%mass = 1.0_8
        p(i)%radius = 0.02_8
    end do
    open(unit=60, file='results/ke_time.dat')
    do step = 1, 5000
        call zero_forces(p)
        call add_gravity(p)
        call wall_forces(p)
        call particle_contacts(p)
        call integrate_particles(p)
        if (mod(step, 100) == 0) then
            ke = compute_kinetic_energy(p)
            write(60, *) step*DT, ke
            call save_snapshot(p, step)
        end if
    end do
    close(60)
end program main
