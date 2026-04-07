module physics
    use types
    use params
    implicit none
contains
    subroutine zero_forces(p)
        type(Particle), intent(inout) :: p
        p%f = 0.0_8
    end subroutine
    subroutine add_gravity(p)
        type(Particle), intent(inout) :: p
        p%f(3) = p%f(3) + p%mass * G
    end subroutine
    subroutine integrate_velocity(p)
        type(Particle), intent(inout) :: p
        p%v = p%v + (p%f / p%mass) * DT
    end subroutine
    subroutine integrate_position(p)
        type(Particle), intent(inout) :: p
        p%x = p%x + p%v * DT
    end subroutine
end module physics
