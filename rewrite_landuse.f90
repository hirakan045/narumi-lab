!　実行はするには下記のコマンドを実行する
!  gfortran rewrite_landuse.f90 -L/usr/local/netcdf-4.1.3/lib -lnetcdf -L/usr/lib -lnetcdff
program main
!
  implicit none
  include '/usr/local/netcdf-4.1.3/include/netcdf.inc'
!
  integer, parameter :: lats=120, lons=120, land=41 ! 次元長 
  integer istatus, ncid                                     ! netCDF ID
  integer ilon, ilat, imon, iland
  integer landmaskid, lu_indexid,landusefid                 ! 変数 ID
  integer :: landmask(lons, lats)                           ! 変数 LANDMASK
  integer :: lu_index(lons, lats)                           ! 変数 LU_INDEX
  real(4) :: landusef(lons, lats, land)                     ! 変数 LANDUSEF
  integer :: rw_landmask(lons, lats)                        ! 上書きするLANDMASK
  integer :: rw_lu_index(lons, lats)                        ! 上書きするLU_INDEX
  real(4) :: rw_landusef(lons, lats, land)                  ! 上書きするLANDUSEF
!
! --- netCDF fileを開く
  istatus = nf_open ('geo_em.d03.nc', nf_write, ncid)
  if (istatus .ne. nf_noerr) call handle_err(istatus)
!
! --- 各変数のIDを取得する
  istatus = nf_inq_varid (ncid, 'LANDMASK', landmaskid)
  if (istatus .ne. nf_noerr) call handle_err(istatus)
!
  istatus = nf_inq_varid (ncid, 'LU_INDEX', lu_indexid)
  if (istatus .ne. nf_noerr) call handle_err(istatus)
!
  istatus = nf_inq_varid (ncid, 'LANDUSEF', landusefid)
  if (istatus .ne. nf_noerr) call handle_err(istatus)
!
!
! --- 値を取得
! --- landmask
  istatus = nf_get_var_int (ncid, landmaskid, landmask)
  if (istatus .ne. nf_noerr) call handle_err(istatus)
! --- lu_index
  istatus = nf_get_var_int (ncid, lu_indexid, lu_index)
  if (istatus .ne. nf_noerr) call handle_err(istatus)
! --- landusef
  istatus = nf_get_var_real (ncid, landusefid, landusef)
  if (istatus .ne. nf_noerr) call handle_err(istatus)
!
!
! --- 上書きするファイルを開く
  open(100,file='landmask.txt')
  open(110,file='lu_index.txt')
  open(220,file='landusef.txt')
! ---
  do ilat = 1, lats
    read(100,*) (rw_landmask(ilon, ilat), ilon = 1, lons)
    read(110,*) (rw_lu_index(ilon, ilat), ilon = 1, lons)
  enddo

  do iland = 1, land
    do ilat = 1, lats
      read(220,*) (rw_landusef(ilon, ilat, iland), ilon = 1, lons)
    enddo
  enddo
!
! --- 各変数の書き換え
  landmask(:,:) = rw_landmask(:,:)
  lu_index(:,:) = rw_lu_index(:,:)
  landusef(:,:,:) = rw_landusef(:,:,:)
!
! --- 各変数の書き換え後の値をnetCDF fileに書き込む
  istatus = nf_put_var_int (ncid, landmaskid, landmask)
  if (istatus .ne. nf_noerr) call handle_err(istatus)
!
  istatus = nf_put_var_int (ncid, lu_indexid, lu_index)
  if (istatus .ne. nf_noerr) call handle_err(istatus)
!
  istatus = nf_put_var_real (ncid, landusefid, landusef)
  if (istatus .ne. nf_noerr) call handle_err(istatus)
!
!
! --- netCDF fileを閉じる
  istatus = nf_close(ncid)
  if (istatus .ne. nf_noerr) call handle_err(istatus)
!
  print *,'*** success re-writing landmask lu_index landusef! ***'
!
end program main
!
!
subroutine handle_err(istatus)
!エラーメッセージを出して止めるsubroutine
  integer istatus
  write(*,*) nf_strerror(istatus)
  stop
end subroutine handle_err
