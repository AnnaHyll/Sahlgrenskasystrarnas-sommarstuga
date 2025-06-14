<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'
    xmlns:XMP-exif='http://ns.exiftool.org/XMP/XMP-exif/1.0/'
    xmlns:IFD0='http://ns.exiftool.org/EXIF/IFD0/1.0/'
    xmlns:XMP-xmp='http://ns.exiftool.org/XMP/XMP-xmp/1.0/'
    xmlns:html="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xs rdf tei IFD0 XMP-exif XMP-xmp html" version="1.0">
    <xsl:output method="html"/>
    <!-- This XLST template is intended to be used with a teiCorpus without contents to show in 
        any text element -->

    <!-- transform the root element into an HTML template -->
    <xsl:template match="tei:teiCorpus">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <html lang="sv" xml:lang="sv">
            <head>
                <title>
                    <!-- add the title for the whole collection from the metadata in the common teiHeader. This is what will be shown
                    on your browsers tab-->
                    <xsl:value-of select="//tei:teiCorpus/tei:teiHeader//tei:title"/>
                </title>
                <!-- load bootstrap css (requires internet!) so you can use their pre-defined css classes to style your html -->
                <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous"/>
                <!-- load the stylesheets in the assets/css folder, where you can modify the styling of your website -->
                <link rel="stylesheet" href="assets/css/main.css"/>
                <link rel="stylesheet" href="assets/css/desktop.css"/>
            </head>
            <body>
                <header>
                    <h1>                        <!-- We choose the contents of the html:title to be the same as the html:h1 -->
                        <xsl:apply-templates select="/tei:teiCorpus/tei:teiHeader//tei:title"/>
                    </h1>

                    <p>
                        Urval och sammanställning av:  <span style="font-style:italic"><xsl:apply-templates select="/tei:teiCorpus/tei:teiHeader//tei:publicationStmt/tei:authority"/></span>  
                    </p>
                </header>
                <nav id="sitenav">
                    <!-- Assuming you will have a set of parallell web pages.
                    You might only have one, so you'll have to edit this navigation bar-->
                    <a href="index.html">Hem</a> |
                    <a href="album.html">Fotoalbum</a> |
                    <a href="">Brev 2</a> 
                </nav>


                <main id="manuscript">
                    <!-- bootstrap "container" class makes the columns look pretty -->
                    <div class="container">
                        <!-- define a row layout with bootstrap's css classes (two columns) -->

                        <div class="row">
                            <!-- introductory text to appear before collection 
                            Please edit for your own adaptation.
                            -->


                            <div id="introduction">
                                <!--  
                                    -->
                                <p>
                                    <xsl:apply-templates select="/tei:teiCorpus/tei:teiHeader/tei:profileDesc/tei:creation"/>
                                </p>

       




                            
                                <!-- These keywords are extracted from the tei:profileDesc -->
                               


                            </div>

                        </div>

                        <!-- xsl:for-each gör att innehållet i xsl-element gör samma sak med
                        alla TEI-element i din teiCorpus -->
                        <xsl:for-each select="/tei:teiCorpus/tei:TEI">


                            <div class="row">
                                <!-- first column: load the image residing in /assets/img folder -->
                                <div class="col-sm">
                                    <article class="scan">
                                        <h2>Faksimil</h2>

                                        <img width="500">
                                            <xsl:attribute name="src">
                                                <xsl:value-of select="tei:facsimile/tei:surface/tei:figure/tei:graphic[1]/@url"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="title">
                                                <xsl:value-of select="tei:facsimile/tei:surface/tei:figure/tei:label"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="alt">
                                                <xsl:value-of select="tei:facsimile/tei:surface/tei:figure/tei:figDesc"/>
                                            </xsl:attribute>
                                        </img>


                                    </article>
                                </div>
                                <!-- second column: apply matching templates for anything you want
                            beside the facsimile -->
                                <div class="col-sm">
                                    <article class="transkribering">
                                        <h2>Transkribering</h2>
<xsl:for-each select="tei:text">
    <div class="extract" style="border:1px solid green;padding:1em">
        <xsl:apply-templates select="tei:body"/>
    </div>
    
</xsl:for-each>
                                    
                                    </article>
                                </div>
                            </div>
                        </xsl:for-each>
                    </div>
                </main>

            </body>
        </html>
    </xsl:template>

    <!-- by default all text nodes are printed out, unless something else is defined.
    We don't want to show the metadata. So we write a template for the teiHeader that
    stops the text nodes underneath (=nested in) teiHeader from being printed into our
    html. This does not hold back elements in the tei header where th xpath is more 
     precise -->
    <xsl:template match="tei:teiHeader"/>

    <!-- turn tei linebreaks (lb) into html linebreaks (br) -->
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    <!-- note: in the previous template there is no <xsl:apply-templates/>. This is because there is nothing to
    process underneath (nested in) tei lb's. Therefore the XSLT processor does not need to look for templates to
    apply to the nodes nested within it.-->

    <!-- we turn the tei head element (headline) into an html h2 element, reserving the html:h1
    for the first heading only -->
    <xsl:template match="tei:head">
        <h2>
            <xsl:apply-templates/>
        </h2>
    </xsl:template>

    <!-- transform tei paragraphs into html paragraphs -->
    <xsl:template match="tei:p">
        <p>
            <!-- apply matching templates for anything that was contained in tei:p -->
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- transform tei:del into html:del. They actually have a
    close relationship in meaning.
    -->
    <xsl:template match="tei:del">
        <del>
            <xsl:apply-templates/>
        </del>
    </xsl:template>

    <!-- transform tei add into html sup -->
    <xsl:template match="tei:add">
        <sup>
            <xsl:apply-templates/>
        </sup>
    </xsl:template>

    <!-- transform tei hi (highlighting) with the attribute @rend="u" into html u elements -->
    <!-- how to read the match? "For all tei:hi elements that have a rend attribute with the value 'u', do the following". Note the need for single quotes inside double quotes -->
    <xsl:template match="tei:hi[@rend = 'u']">
        <u>
            <xsl:apply-templates/>
        </u>
    </xsl:template>

    <xsl:template match="//tei:teiHeader//tei:date">
        <b>
            <xsl:apply-templates/>
        </b>
    </xsl:template>

    <xsl:template match="tei:persName">
        <a href="{./@ref}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    <xsl:template match="tei:ref">
        <a href="{./@target}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>



</xsl:stylesheet>
