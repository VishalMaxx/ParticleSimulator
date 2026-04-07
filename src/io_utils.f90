module io_utils
    use types
    implicit none
contains
    subroutine save_snapshot(p, timestep)
        type(Particle), intent(in) :: p(:)
        integer, intent(in) :: timestep
        integer :: i, unit_num
        character(len=32) :: filename
        write(filename, '(A,I0.6,A)') 'results/snap_', timestep, '.dat'
        open(newunit=unit_num, file=filename)
        do i = 1, size(p)
            write(unit_num, *) p(i)%x(1), p(i)%x(2), p(i)%x(3), p(i)%radius
        end do
        close(unit_num)
    end subroutine
end module io_utils
