program main
    use types
    use params
    use physics
    implicit none
    type(Particle) :: p
    integer :: i, n_steps
    open(unit=10, file='results/trajectory.dat')
    p%x = [0.5_8, 0.5_8, 0.8_8]
    p%v = [0.0_8, 0.0_8, 0.0_8]
    p%mass = 1.0_8
    p%radius = 0.05_8
    n_steps = 20000
    do i = 1, n_steps
        call zero_forces(p)
        call add_gravity(p)
        call wall_forces(p)
        call integrate_velocity(p)
        call integrate_position(p)
        if (mod(i, 100) == 0) then
            write(10, *) i*DT, p%x(3), p%v(3)
        end if
    end do
    close(10)
end program main
