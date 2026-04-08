program get_com
    use types
    use params
    use physics
    use grid_search
    implicit none
    type(Particle), allocatable :: p(:)
    real(8) :: com_z, z_sum
    integer :: i, step
    allocate(p(100))
    
    call random_seed()
    do i = 1, 100
        call random_number(p(i)%x)
        p(i)%x = p(i)%x * 0.7_8 + 0.1_8
        p(i)%v = 0.0_8
        p(i)%f = 0.0_8
        p(i)%mass = 1.0_8
        p(i)%radius = 0.01_8
    end do

    ! Fix: Initialize grid before use
    call init_grid([1.0_8, 1.0_8, 1.0_8], 0.03_8)

    open(unit=99, file='results/com_height.dat')
    do step = 1, 2000
        call zero_forces(p)
        call add_gravity(p)
        call wall_forces(p)
        call particle_contacts_grid(p)
        call integrate_particles(p)
        
        ! Fix: Manual sum for CoM Z-height
        z_sum = 0.0_8
        do i = 1, 100
            z_sum = z_sum + p(i)%x(3)
        end do
        com_z = z_sum / 100.0_8
        
        write(99, *) step*0.001, com_z
    end do
    close(99)
    print *, "Data successfully saved to results/com_height.dat"
end program
