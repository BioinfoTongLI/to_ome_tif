#!/usr/bin/env/ nextflow
// Copyright © 2023 Tong LI <tongli.bioinfo@proton.me>

nextflow.enable.dsl=2
params.out_dir = "./test/"
params.files_in = [
    ['meta_map', 'image-to-convert'],
    ['meta_map2', 'image-to-convert2'],
]

include { BIOINFOTONGLI_TO_OME_TIFF } from '../subworkflows/sanger/bioinfotongli/to_ome_tiff/main' addParams(
    out_dir:params.out_dir
)

 include { BIOINFOTONGLI_BIOFORMATS2RAW } from '../modules/sanger/bioinfotongli/bioformats2raw/main' addParams(
    out_dir:params.out_dir
)

workflow TO_OME_TIF {
    BIOINFOTONGLI_TO_OME_TIFF(
        channel.from(params.files_in)
    )
}

workflow TO_ZARR {
    BIOINFOTONGLI_BIOFORMATS2RAW(
        channel.from(params.files_in)
    )
}
