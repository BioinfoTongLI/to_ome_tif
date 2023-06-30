#!/usr/bin/env/ nextflow
// Copyright © 2023 Tong LI <tongli.bioinfo@proton.me>

nextflow.enable.dsl=2

inlcude {TO_OME_TIF} from "./workflows/to_ome_tiff"
inlcude {TO_ZARR} from "./workflows/to_ome_tiff"

workflow {
    TO_OME_TIF()
}

workflow TO_ZARR_RUN {
    TO_ZARR()
}
