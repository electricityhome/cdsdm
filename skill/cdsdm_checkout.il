; cdsdm_checkout.il
;

procedure( cdsdm_checkout(lib)
  let( ( path master branch new_branch cid irp )

    path = ddGetObjReadPath(ddGetObj(lib))
    master = cdsdm_git->master
    branch = cdsdm_check_branch(lib)
    new_branch = stringToTime(getCurrentTime())

    when( branch == master
      if( cdsdm_check_remote(lib)=="conflicting" then
	lmgrDisplayMessage("[checkout] *ERROR* conflicting\n")
      else
	cdsdm_permission(path "+")

        cid = ipcBatchProcess( sprintf(nil "%s -C %s checkout -b %d" cdsdm_git->git path new_branch ) "" "" )
        ipcWaitForProcess( cid )
        lmgrDisplayMessage(sprintf(nil "[checkout] Checkout '%d' branch\n" new_branch) )
        while( irp=ipcReadProcess(cid 10) lmgrDisplayMessage(sprintf(nil "[checkout] %s" irp)) )
	cdsdm_cdslib(lib "checkout")
      )
    )

  )
)

;
;
