VERSION = '0.5.0'

process BIOINFOTONGLI_RAW2OMETIFF {
    tag "$meta.id"
    label 'process_medium'

    conda (params.enable_conda ? "-c ome raw2ometiff=${VERSION}" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        "bioinfotongli/raw2ometiff:${VERSION}":
        "bioinfotongli/raw2ometiff:${VERSION}" }"
    publishDir params.out_dir , mode: 'copy'

    input:
    tuple val(meta), path(ome_zarr)

    output:
    tuple val(meta), path("${prefix}.ome.tif"), emit: ome_tif
    path "raw2ometiff_versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    prefix = task.ext.prefix ?: "${meta.id}"
    """
    raw2ometiff \\
        --max_workers=$task.cpus \\
        $args \\
        $ome_zarr \\
        ${prefix}.ome.tif

    cat <<-END_VERSIONS > raw2ometiff_versions.yml
    "${task.process}":
        bioinfotongli: \$(echo \$(raw2ometiff --version 2>&1) | sed 's/^.*raw2ometiff //; s/Using.*\$//' ))
    END_VERSIONS
    """
}
