program main
    use types
    use params
    use physics
    use omp_lib
    implicit none
    type(Particle), allocatable :: p(:)
    integer :: i, step, n_p, n_threads, t_idx
    real(8) :: t_start, t_end
    integer :: thread_counts(3) = [1, 2, 4]

    n_p = 2000
    open(unit=80, file='results/parallel_scaling.dat')
    write(80, *) "# Threads  Time(s)"

    do t_idx = 1, 3
        n_threads = thread_counts(t_idx)
        call omp_set_num_threads(n_threads)
        
        if (allocated(p)) deallocate(p)
        allocate(p(n_p))
        call random_seed()
        do i = 1, n_p
            call random_number(p(i)%x)
            p(i)%x = p(i)%x * 0.8_8 + 0.1_8
            p(i)%v = 0.0_8
            p(i)%mass = 1.0_8
            p(i)%radius = 0.01_8
        end do

        t_start = omp_get_wtime()
        do step = 1, 200
            call zero_forces(p)
            call add_gravity(p)
            call wall_forces(p)
            call particle_contacts(p)
            call integrate_particles(p)
        end do
        t_end = omp_get_wtime()
        
        write(80, *) n_threads, t_end - t_start
        print *, "Threads:", n_threads, " Time:", t_end - t_start
    end do
    close(80)
end program main
