program main
    use types
    use params
    use physics
    implicit none
    type(Particle) :: p
    integer :: i, n_steps
    p%x = [0.0_8, 0.0_8, 10.0_8]
    p%v = [0.0_8, 0.0_8, 0.0_8]
    p%mass = 1.0_8
    p%radius = 0.1_8
    n_steps = 1000
    do i = 1, n_steps
        call zero_forces(p)
        call add_gravity(p)
        call integrate_velocity(p)
        call integrate_position(p)
        if (mod(i, 100) == 0) then
            print *, "Step:", i, " Time:", i*DT, " Height:", p%x(3)
        end if
    end do
end program main
