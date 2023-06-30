//
// Convert any microscopy image to ome.tiff
//

include { BIOINFOTONGLI_BIOFORMATS2RAW as bf2raw } from '../../../../modules/sanger/bioinfotongli/bioformats2raw/main'
include { BIOINFOTONGLI_RAW2OMETIFF as raw2ometiff } from '../../../../modules/sanger/bioinfotongli/raw2ometiff/main'

workflow BIOINFOTONGLI_TO_OME_TIFF {
    take:
    images // channel: [ val(meta), file(image) ]

    main:

    ch_versions = Channel.empty()

    //
    // Convert images to ome.zarr
    //

    bf2raw ( images )
    ch_versions = ch_versions.mix(bf2raw.out.versions.first())

    //
    // Convert ome.zarr to ome.tiff
    //
    raw2ometiff ( bf2raw.out.zarr )
    ch_versions = ch_versions.mix(raw2ometiff.out.versions)

    emit:
    ome_tif        = raw2ometiff.out.ome_tif     // channel: [ val(meta), ome_tif ]

    versions       = ch_versions                      // channel: [ versions.yml ]
}
