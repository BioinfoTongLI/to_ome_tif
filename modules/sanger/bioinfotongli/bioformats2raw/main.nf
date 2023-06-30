VERSION = '0.5.0'

process BIOINFOTONGLI_BIOFORMATS2RAW {
    tag "${meta.id}"
    label 'process_medium'

    conda (params.enable_conda ? "-c ome bioformats2raw==${VERSION}" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        "openmicroscopy/bioformats2raw:${VERSION}":
        "openmicroscopy/bioformats2raw:${VERSION}" }"
    publishDir params.out_dir, mode: 'copy'

    input:
    tuple val(meta), path(img)

    output:
    tuple val(meta), path("${stem}.zarr"), emit: zarr
    path "bioformats2raw_versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    stem = meta['id'] ?: img.baseName
    def args = task.ext.args ?: ''
    """
    JAVA_HOME='/opt/conda/lib/jvm' /opt/conda/bin/bioformats2raw \\
        --max_workers=$task.cpus \\
        $args \\
        $img \\
        "${stem}.zarr"

    cat <<-END_VERSIONS > bioformats2raw_versions.yml
    "${task.process}":
        bioinfotongli: \$(echo \$(JAVA_HOME='/opt/conda/lib/jvm' /opt/conda/bin/bioformats2raw --version 2>&1) | sed 's/^.*bioformats2raw //; s/Using.*\$//' ))
    END_VERSIONS
    """
}
