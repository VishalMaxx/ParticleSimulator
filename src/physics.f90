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
    subroutine wall_forces(p)
        type(Particle), intent(inout) :: p
        real(8) :: dist, overlap, v_rel, f_mag
        real(8) :: box(3)
        integer :: d
        box = [1.0_8, 1.0_8, 1.0_8]
        do d = 1, 3
            dist = p%x(d)
            overlap = p%radius - dist
            if (overlap > 0.0_8) then
                v_rel = p%v(d)
                f_mag = KN * overlap - GAMMA_N * v_rel
                p%f(d) = p%f(d) + max(0.0_8, f_mag)
            end if
            dist = box(d) - p%x(d)
            overlap = p%radius - dist
            if (overlap > 0.0_8) then
                v_rel = -p%v(d)
                f_mag = KN * overlap - GAMMA_N * v_rel
                p%f(d) = p%f(d) - max(0.0_8, f_mag)
            end if
        end do
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
