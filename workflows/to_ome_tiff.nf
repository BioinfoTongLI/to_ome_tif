#!/usr/bin/env/ nextflow
// Copyright © 2023 Tong LI <tongli.bioinfo@proton.me>

nextflow.enable.dsl=2
params.out_dir = "./test/"
params.file_in = "image-to-convert"

include { BIOINFOTONGLI_TO_OME_TIFF } from '../subworkflows/sanger/bioinfotongli/to_ome_tiff/main' addParams(
    enable_conda:false,
    publish:false,
    store:true,
    out_dir:params.out_dir
)

 include { BIOINFOTONGLI_BIOFORMATS2RAW } from '../modules/sanger/bioinfotongli/bioformats2raw/main' addParams(
    enable_conda:false,
    publish:false,
    store:true,
    out_dir:params.out_dir
)

workflow {
    BIOINFOTONGLI_TO_OME_TIFF(
        channel.from(
            [
                [["id":"test"], file(params.file_in)],
            ]
        )
    )
}

workflow to_zarr {
    BIOINFOTONGLI_BIOFORMATS2RAW(
        channel.from(
            [
                /*[["id":"WellA1_Seq0002"], file("/lustre/scratch126/cellgen/team283/tl10/Freddy_3D_seg/T221D W15 SB1-5/WellA1_ChannelSD Red FW,SD FarRed FW_Seq0002.nd2")],*/
                [["id":"test"], file(params.file_in)],
                /*[["id":"T265C_WellA1_Seq0002"], file("/lustre/scratch126/cellgen/team283/tl10/Freddy_3D_seg/T265C NTG1/WellA1_ChannelSD Red FW,SD FarRed FW_Seq0002.nd2")],*/
                /*[["id":"T265C_WellB1_Seq0003"], file("/lustre/scratch126/cellgen/team283/tl10/Freddy_3D_seg/T265C NTG1/WellB1_ChannelSD Red FW,SD FarRed FW_Seq0003.nd2")],*/
            ]
        )
    )
}
