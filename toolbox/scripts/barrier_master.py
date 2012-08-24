#!/usr/bin/env python2.6

"""Master script for barrier analysis in linkage mapper.

Reguired Software:
ArcGIS 10 with Spatial Analyst extension
Python 2.6
Numpy

"""

import os.path as path
import sys

import arcpy

from lm_config import tool_env as cfg
import lm_util as lu
import s6_barriers as s6


_SCRIPT_NAME = "barrier_master.py"

def bar_master():
    """ Experimental code to detect barriers using cost-weighted distance
    outputs from Linkage Mapper tool.

    """
    cfg.configure(cfg.TOOL_BM, sys.argv)
    gprint = lu.gprint
    try:
        
        lu.create_dir(cfg.LOGDIR)
        lu.create_dir(cfg.MESSAGEDIR)

        cfg.logFilePath = lu.create_log_file(cfg.MESSAGEDIR, cfg.TOOL, 
                                             cfg.PARAMS)

        lu.print_drive_warning()

        # Move adj and cwd results from earlier versions to datapass directory
        lu.move_old_results()

        lu.create_dir(cfg.OUTPUTDIR)
        lu.delete_dir(cfg.SCRATCHDIR)
        lu.create_dir(cfg.SCRATCHDIR)
        lu.create_dir(cfg.ARCSCRATCHDIR)
        
        gprint('\nMaking local copy of resistance raster.')
        lu.delete_data(cfg.RESRAST)

        desc = arcpy.Describe(cfg.RESRAST_IN)
        if hasattr(desc, "catalogPath"):
            cfg.RESRAST_IN = arcpy.Describe(cfg.RESRAST_IN).catalogPath
            
        arcpy.CopyRaster_management(cfg.RESRAST_IN, cfg.RESRAST)
        arcpy.env.extent = cfg.RESRAST
        arcpy.env.snapRaster = cfg.RESRAST
        
        if cfg.BARRIER_METH_MAX:
            cfg.SUM_BARRIERS = False
            lu.dashline(1)
            gprint('Calculating MAXIMUM barrier effects across core area pairs')
            s6.STEP6_calc_barriers()

        if cfg.BARRIER_METH_SUM:
            cfg.SUM_BARRIERS = True
            gprint('')
            lu.dashline()
            gprint('Calculating SUM of barrier effects across core area pairs')
            s6.STEP6_calc_barriers()
        
        #clean up
        lu.delete_dir(cfg.SCRATCHDIR)
        if not cfg.SAVEBARRIERDIR:
            lu.delete_dir(cfg.BARRIERBASEDIR)
        gprint('\nDONE!\n')

    # Return GEOPROCESSING specific errors
    except arcpy.ExecuteError:
        lu.exit_with_geoproc_error(_SCRIPT_NAME)

    # Return any PYTHON or system specific errors
    except:
        lu.exit_with_python_error(_SCRIPT_NAME)

if __name__ == "__main__":
    bar_master()

