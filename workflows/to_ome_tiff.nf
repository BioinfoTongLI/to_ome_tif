#!/usr/bin/env/ nextflow
// Copyright © 2023 Tong LI <tongli.bioinfo@proton.me>

nextflow.enable.dsl=2
params.out_dir = "./test/"
params.file_in = "image-to-convert"

include { BIOINFOTONGLI_TO_OME_TIFF } from '../subworkflows/sanger/bioinfotongli/to_ome_tiff/main' addParams(
    out_dir:params.out_dir
)

 include { BIOINFOTONGLI_BIOFORMATS2RAW } from '../modules/sanger/bioinfotongli/bioformats2raw/main' addParams(
    out_dir:params.out_dir
)

workflow TO_OME_TIF {
    BIOINFOTONGLI_TO_OME_TIFF(
        channel.from(
            [
                [["id":"test"], file(params.file_in)],
            ]
        )
    )
}

workflow TO_ZARR {
    BIOINFOTONGLI_BIOFORMATS2RAW(
        channel.from(
            [
                [["id":"test"], file(params.file_in)],
            ]
        )
    )
}
