module physics
    use types
    use params
    implicit none
contains
    subroutine zero_forces(p)
        type(Particle), intent(inout) :: p(:)
        integer :: i
        !$omp parallel do
        do i = 1, size(p)
            p(i)%f = 0.0_8
        end do
        !$omp end parallel do
    end subroutine

    subroutine add_gravity(p)
        type(Particle), intent(inout) :: p(:)
        integer :: i
        !$omp parallel do
        do i = 1, size(p)
            p(i)%f(3) = p(i)%f(3) + p(i)%mass * G
        end do
        !$omp end parallel do
    end subroutine

    subroutine wall_forces(p)
        type(Particle), intent(inout) :: p(:)
        real(8) :: dist, overlap, v_rel, f_mag
        real(8) :: box(3)
        integer :: i, d
        box = [1.0_8, 1.0_8, 1.0_8]
        !$omp parallel do private(d, dist, overlap, v_rel, f_mag)
        do i = 1, size(p)
            do d = 1, 3
                dist = p(i)%x(d)
                overlap = p(i)%radius - dist
                if (overlap > 0.0_8) then
                    v_rel = p(i)%v(d)
                    f_mag = KN * overlap - GAMMA_N * v_rel
                    p(i)%f(d) = p(i)%f(d) + max(0.0_8, f_mag)
                end if
                dist = box(d) - p(i)%x(d)
                overlap = p(i)%radius - dist
                if (overlap > 0.0_8) then
                    v_rel = -p(i)%v(d)
                    f_mag = KN * overlap - GAMMA_N * v_rel
                    p(i)%f(d) = p(i)%f(d) - max(0.0_8, f_mag)
                end if
            end do
        end do
        !$omp end parallel do
    end subroutine

    subroutine particle_contacts(p)
        type(Particle), intent(inout) :: p(:)
        real(8) :: r_ij(3), d_ij, n_ij(3), delta_ij, v_rel(3), vn_ij, f_mag, f_vec(3)
        integer :: i, j, n
        n = size(p)
        !$omp parallel do private(j, r_ij, d_ij, delta_ij, n_ij, v_rel, vn_ij, f_mag, f_vec)
        do i = 1, n - 1
            do j = i + 1, n
                r_ij = p(j)%x - p(i)%x
                d_ij = sqrt(sum(r_ij**2))
                delta_ij = p(i)%radius + p(j)%radius - d_ij
                if (delta_ij > 0.0_8) then
                    if (d_ij > 1.0d-12) then
                        n_ij = r_ij / d_ij
                        v_rel = p(j)%v - p(i)%v
                        vn_ij = sum(v_rel * n_ij)
                        f_mag = max(0.0_8, KN * delta_ij - GAMMA_N * vn_ij)
                        f_vec = f_mag * n_ij
                        !$omp atomic
                        p(i)%f(1) = p(i)%f(1) - f_vec(1)
                        !$omp atomic
                        p(i)%f(2) = p(i)%f(2) - f_vec(2)
                        !$omp atomic
                        p(i)%f(3) = p(i)%f(3) - f_vec(3)
                        !$omp atomic
                        p(j)%f(1) = p(j)%f(1) + f_vec(1)
                        !$omp atomic
                        p(j)%f(2) = p(j)%f(2) + f_vec(2)
                        !$omp atomic
                        p(j)%f(3) = p(j)%f(3) + f_vec(3)
                    end if
                end if
            end do
        end do
        !$omp end parallel do
    end subroutine

    subroutine integrate_particles(p)
        type(Particle), intent(inout) :: p(:)
        integer :: i
        !$omp parallel do
        do i = 1, size(p)
            p(i)%v = p(i)%v + (p(i)%f / p(i)%mass) * DT
            p(i)%x = p(i)%x + p(i)%v * DT
        end do
        !$omp end parallel do
    end subroutine

    function compute_kinetic_energy(p) result(ke)
        type(Particle), intent(in) :: p(:)
        real(8) :: ke
        integer :: i
        ke = 0.0_8
        !$omp parallel do reduction(+:ke)
        do i = 1, size(p)
            ke = ke + 0.5_8 * p(i)%mass * sum(p(i)%v**2)
        end do
        !$omp end parallel do
    end function
end module physics
