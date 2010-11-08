<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:html="http://www.w3.org/1999/xhtml"
    version="1.0">
    <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/html/chunk.xsl" />
    
    <xsl:output method="html" encoding="UTF-8" indent="yes" />
    
    <!-- Chunking -->
    <xsl:param name="chunker.output.indent" select="'yes'" />
    <xsl:param name="use.id.as.filename" select="1" />
    <xsl:param name="chunk.section.depth" select="0" />
    <xsl:param name="chunker.output.encoding">UTF-8</xsl:param>
    
    <!-- Default CSS stylesheet -->
    <xsl:param name="html.stylesheet">screen.css</xsl:param>
    
    <xsl:param name="toc.section.depth" select="1" />
    
    <xsl:param name="section.autolabel" select="1" />
    <xsl:param name="section.label.includes.component.label" select="1" />
</xsl:stylesheet>