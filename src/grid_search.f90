module grid_search
    use types
    use params
    implicit none
    integer :: n_cells(3)
    real(8) :: cell_size(3)
    integer, allocatable :: head(:)
    integer, allocatable :: next(:)

contains
    subroutine init_grid(box_l, r_cut)
        real(8), intent(in) :: box_l(3), r_cut
        n_cells = max(1, floor(box_l / r_cut))
        cell_size = box_l / real(n_cells, 8)
        if (allocated(head)) deallocate(head)
        if (allocated(next)) deallocate(next)
        allocate(head(product(n_cells)))
    end subroutine

    subroutine build_grid(p)
        type(Particle), intent(in) :: p(:)
        integer :: i, ic(3), cell_idx
        if (.not. allocated(next)) allocate(next(size(p)))
        head = 0
        do i = 1, size(p)
            ic = min(n_cells, max(1, floor(p(i)%x / cell_size) + 1))
            cell_idx = ic(1) + (ic(2)-1)*n_cells(1) + (ic(3)-1)*n_cells(1)*n_cells(2)
            next(i) = head(cell_idx)
            head(cell_idx) = i
        end do
    end subroutine
end module grid_search
