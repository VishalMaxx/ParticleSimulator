program main
    use types
    use params
    use physics
    use grid_search
    use omp_lib
    implicit none

    type(Particle), allocatable :: p(:)
    integer :: n_list(4) = [100, 500, 1000, 2000]
    integer :: i, n, step, e_step
    real(8) :: t1, t2, time_brute, time_grid
    real(8) :: current_dt, final_error, z_final, z_analyt, total_time

    
    open(unit=150, file='results/grid_vs_brute.dat')
    write(150, *) "# N  Brute_Time(s)  Grid_Time(s)"

    do i = 1, 4
        n = n_list(i)
        allocate(p(n))
        call random_seed()
        do step = 1, n
            call random_number(p(step)%x)
            p(step)%v = 0.0_8; p(step)%mass = 1.0_8; p(step)%radius = 0.01_8
        end do

        ! Benchmark Brute Force----------------------------------------
        t1 = omp_get_wtime()
        do step = 1, 100
            call particle_contacts_brute(p)
        end do
        t2 = omp_get_wtime()
        time_brute = t2 - t1
!----------------------------------------------------------------------------

        ! Benchmark Grid Search----------------------------------------
        call init_grid([1.0_8, 1.0_8, 1.0_8], 0.03_8)
        t1 = omp_get_wtime()
        do step = 1, 100
            call particle_contacts_grid(p)
        end do
        t2 = omp_get_wtime()
        time_grid = t2 - t1
!--------------------------------------------------------------------------------------
        write(150, *) n, time_brute, time_grid
        print *, "N=", n, " Brute Time:", time_brute, " Grid Time:", time_grid
        deallocate(p)
    end do
    close(150)

    
    open(unit=60, file='results/error_study.dat')
    total_time = 1.0_8 
    
    do i = 1, 5
        current_dt = 0.1_8 / (2.0_8**(i-1)) 
        z_final = 10.0_8 
        t1 = 0.0_8 
        t2 = 0.0_8 
        
        
        do e_step = 1, nint(total_time / current_dt)
            t2 = t2 + G * current_dt
            z_final = z_final + t2 * current_dt
        end do
        
        
        z_analyt = 10.0_8 + 0.5_8 * G * (total_time**2)
        final_error = abs(z_final - z_analyt)
        
        write(60, *) current_dt, final_error
        print *, "DT:", current_dt, " Error:", final_error
    end do
    close(60)

    print *, "All studies completed. Run python3 generate_plots.py now."
end program main
