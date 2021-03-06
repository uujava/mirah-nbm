<?xml version="1.0" encoding="UTF-8"?>
<!--
DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.

Copyright 1997-2010 Oracle and/or its affiliates. All rights reserved.

Oracle and Java are registered trademarks of Oracle and/or its affiliates.
Other names may be trademarks of their respective owners.


The contents of this file are subject to the terms of either the GNU
General Public License Version 2 only ("GPL") or the Common
Development and Distribution License("CDDL") (collectively, the
"License"). You may not use this file except in compliance with the
License. You can obtain a copy of the License at
http://www.netbeans.org/cddl-gplv2.html
or nbbuild/licenses/CDDL-GPL-2-CP. See the License for the
specific language governing permissions and limitations under the
License.  When distributing the software, include this License Header
Notice in each file and include the License file at
nbbuild/licenses/CDDL-GPL-2-CP.  Oracle designates this
particular file as subject to the "Classpath" exception as provided
by Oracle in the GPL Version 2 section of the License file that
accompanied this code. If applicable, add the following below the
License Header, with the fields enclosed by brackets [] replaced by
your own identifying information:
"Portions Copyrighted [year] [name of copyright owner]"

Contributor(s):

The Original Software is NetBeans. The Initial Developer of the Original
Software is Sun Microsystems, Inc. Portions Copyright 1997-2007 Sun
Microsystems, Inc. All Rights Reserved.

If you wish your version of this file to be governed by only the CDDL
or only the GPL Version 2, indicate your decision by adding
"[Contributor] elects to include this software in this distribution
under the [CDDL or GPL Version 2] license." If you do not indicate a
single choice of license, a recipient has the option to distribute
your version of this file under either the CDDL, the GPL Version 2 or
to extend the choice of license to its licensees as provided above.
However, if you add GPL Version 2 code and therefore, elected the GPL
Version 2 license, then the option applies only if the new code is
made subject to such option by the copyright holder.
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:p="http://www.netbeans.org/ns/project/1"
                xmlns:xalan="http://xml.apache.org/xslt"
                xmlns:webproject1="http://www.netbeans.org/ns/web-project/1"
                xmlns:webproject2="http://www.netbeans.org/ns/web-project/2"
                xmlns:webproject3="http://www.netbeans.org/ns/web-project/3"
                exclude-result-prefixes="xalan p webproject1 webproject2 webproject3">
    <xsl:output method="xml" indent="yes" encoding="UTF-8" xalan:indent-amount="4"/>
    <xsl:template match="/">

        <xsl:variable name="name" select="/p:project/p:configuration/webproject3:data/webproject3:name"/>
        <xsl:variable name="codename" select="translate($name, ' ', '_')"/>
        <project>
             <condition property="mirah.use_default_javac">
                <or>
                  <isset property="codename1.displayName"/>
                  <isset property="codename1.is_library"/>
                </or>
              </condition>
            <property name="test.binaryincludes" value="**/*Test.class"/>
            <property name="test.binarytestincludes" value="**/*Test.class"/>
            <target name="-mirah-pre-init">
                <mkdir dir="build/mirah"></mkdir>
            </target>
            <target name="-mirah-init-macrodef-javac" unless="mirah.use_default_javac">
                <mkdir dir="build/mirah"></mkdir>
                <macrodef>
                    <xsl:attribute name="name">javac</xsl:attribute>
                   <xsl:attribute name="uri">http://www.netbeans.org/ns/web-project/2</xsl:attribute>
                    <attribute>
                        <xsl:attribute name="name">srcdir</xsl:attribute>
                        <xsl:attribute name="default">
                            <xsl:call-template name="createPath">
                                <xsl:with-param name="roots" select="/p:project/p:configuration/webproject3:data/webproject3:source-roots"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </attribute>
                    <attribute>
                        <xsl:attribute name="name">destdir</xsl:attribute>
                        <xsl:attribute name="default">${build.classes.dir}</xsl:attribute>
                    </attribute>
                    <attribute>
                        <xsl:attribute name="name">classpath</xsl:attribute>
                        <xsl:attribute name="default">${javac.classpath}:${j2ee.platform.classpath}</xsl:attribute>
                    </attribute>
                    <attribute>
                        <xsl:attribute name="name">includes</xsl:attribute>
                        <xsl:attribute name="default">${includes}</xsl:attribute>
                    </attribute>
                    <attribute>
                        <xsl:attribute name="name">excludes</xsl:attribute>
                        <xsl:attribute name="default">${excludes}</xsl:attribute>
                    </attribute>
                    <attribute>
                        <xsl:attribute name="name">debug</xsl:attribute>
                        <xsl:attribute name="default">${javac.debug}</xsl:attribute>
                    </attribute>
                    <attribute>
                        <xsl:attribute name="name">sourcepath</xsl:attribute>
                        <xsl:attribute name="default">${empty.dir}</xsl:attribute>
                    </attribute>
                    <attribute>
                        <xsl:attribute name="name">gensrcdir</xsl:attribute>
                        <xsl:attribute name="default">${empty.dir}</xsl:attribute>
                    </attribute>
                    <attribute>
                        <xsl:attribute name="name">processorpath</xsl:attribute>
                        <xsl:attribute name="default">${javac.processorpath}</xsl:attribute>
                    </attribute>
                    <attribute>
                        <xsl:attribute name="name">apgeneratedsrcdir</xsl:attribute>
                        <xsl:attribute name="default">${build.generated.sources.dir}/ap-source-output</xsl:attribute>
                    </attribute>
                    <element>
                        <xsl:attribute name="name">customize</xsl:attribute>
                        <xsl:attribute name="optional">true</xsl:attribute>
                    </element>
                    <sequential>
                        <taskdef>
                            <xsl:attribute name="name">mirahc</xsl:attribute>
                            <xsl:attribute name="classpath">${libs.mirah-all.classpath}:${javac.classpath}:${j2ee.platform.classpath}</xsl:attribute>
                            <xsl:attribute name="classname">ca.weblite.mirah.ant.MirahcTask</xsl:attribute>
                        </taskdef>
                        <property name="empty.dir" location="${{build.dir}}/empty"/><!-- #157692 -->
                        <mkdir dir="${{empty.dir}}"/>
                        <mkdir>
                            <xsl:attribute name="dir">${build.dir}/mirah</xsl:attribute>
                        </mkdir>
                        
                        <!-- Deal with macros first -->
                        <!-- We're going to use the convention that any classes inside a "macros" package is considered to be macros -->
                        <property name="mirah.tmp" location="${{build.dir}}/mirah_tmp"/>
                        <property name="mirah.tmp.macros" location="${{mirah.tmp}}/macros"/>
                        <property name="mirah.java.stub.dir" location="${{mirah.tmp}}/java_stub_dir"/>
                        <property name="mirah.class.cache.dir" location="${{mirah.tmp}}/class_cache_dir"/>
                        <property name="mirah.tmp.macros.src" location="${{mirah.tmp.macros}}/src"/>
                        <property name="mirah.tmp.macros.classes" location="${{mirah.tmp.macros}}/classes"/>

                        <delete dir="${{mirah.tmp.macros.src}}"/>
                        <mkdir dir="${{mirah.tmp.macros.src}}"/>
                        <copy todir="${{mirah.tmp.macros.src}}">
                          <fileset dir="@{{srcdir}}" includes="**/macros/**" excludes="**/Bootstrap.mirah"/>
                        </copy>
                        <delete dir="${{mirah.tmp.macros.classes}}"/>
                        <mkdir dir="${{mirah.tmp.macros.classes}}"/>

                        <mirahc dest="${{mirah.tmp.macros.classes}}" 
                                macrojardir="${{mirah.macros.jardir}}"
                                macroclasspath="@{{classpath}}"
                                javasourcespath="@{{srcdir}}"
                                javastubdir="${{mirah.java.stub.dir}}"
                                classcachedir="${{mirah.class.cache.dir}}"
                            >
                            <javac srcdir="${{mirah.tmp.macros.src}}" classpath="@{{classpath}}" sourcepath="@{{sourcepath}}" includes="@{{includes}}" excludes="@{{excludes}}" debug="@{{debug}}" deprecation="${{javac.deprecation}}" encoding="${{source.encoding}}" source="${{javac.source}}" target="${{javac.target}}">
                                <compilerarg line="${{javac.compilerargs}}"/>
                                <customize/>
                            </javac>
                        </mirahc>

                        <!-- Now for macro bootstrapping code -->
                        <delete dir="${{mirah.tmp.macros.src}}"/>
                        <mkdir dir="${{mirah.tmp.macros.src}}"/>
                        <copy todir="${{mirah.tmp.macros.src}}">
                          <fileset dir="@{{srcdir}}" includes="**/macros/Bootstrap.mirah"/>
                        </copy>
                        <mirahc dest="${{mirah.tmp.macros.classes}}" 
                                macrojardir="${{mirah.macros.jardir}}" 
                                macroclasspath="${{mirah.tmp.macros.classes}}:@{{classpath}}"
                                javasourcespath="@{{srcdir}}"
                                javastubdir="${{mirah.java.stub.dir}}"
                                classcachedir="${{mirah.class.cache.dir}}"
                            >
                            <javac srcdir="${{mirah.tmp.macros.src}}" classpath="@{{classpath}}:${{mirah.tmp.macros.classes}}" sourcepath="@{{sourcepath}}" includes="@{{includes}}" excludes="@{{excludes}}" debug="@{{debug}}" deprecation="${{javac.deprecation}}" encoding="${{source.encoding}}" source="${{javac.source}}" target="${{javac.target}}">
                                <compilerarg line="${{javac.compilerargs}}"/>
                                <customize/>
                            </javac>
                        </mirahc>

                        
                        <mirahc>
                            <xsl:attribute name="dest">${build.dir}/mirah</xsl:attribute>
                            <xsl:attribute name="macrojardir">${mirah.macros.jardir}</xsl:attribute>
                            <xsl:attribute name="macroclasspath">${mirah.tmp.macros.classes}:@{classpath}</xsl:attribute>
                            <xsl:attribute name="javastubdir">${mirah.java.stub.dir}</xsl:attribute>
                            <xsl:attribute name="classcachedir">${mirah.class.cache.dir}</xsl:attribute>
                             <xsl:attribute name="javasourcespath">@{srcdir}</xsl:attribute>
                            <javac>
                                <xsl:attribute name="srcdir">@{srcdir}</xsl:attribute>
                                <xsl:attribute name="destdir">@{destdir}</xsl:attribute>
                                <xsl:attribute name="classpath">@{classpath}</xsl:attribute>
                                <xsl:attribute name="sourcepath">@{sourcepath}</xsl:attribute>
                                <xsl:attribute name="includes">@{includes}</xsl:attribute>
                                <xsl:attribute name="excludes">@{excludes}</xsl:attribute>
                                
                                
                                <xsl:attribute name="debug">@{debug}</xsl:attribute>
                                <xsl:attribute name="deprecation">${javac.deprecation}</xsl:attribute>
                                <xsl:attribute name="encoding">${source.encoding}</xsl:attribute>
                                <xsl:if test ="not(/p:project/p:configuration/webproject3:data/webproject3:explicit-platform/@explicit-source-supported ='false')">
                                    <xsl:attribute name="source">${javac.source}</xsl:attribute>
                                    <xsl:attribute name="target">${javac.target}</xsl:attribute>
                                </xsl:if>
                                <xsl:if test="/p:project/p:configuration/webproject3:data/webproject3:explicit-platform">
                                    <xsl:attribute name="fork">yes</xsl:attribute>
                                    <xsl:attribute name="executable">${platform.javac}</xsl:attribute>
                                    <xsl:attribute name="tempdir">${java.io.tmpdir}</xsl:attribute>
                                </xsl:if>
                               

                                <compilerarg line="${{javac.compilerargs}}"/>
                                <customize/>
                            </javac>
                        </mirahc>
                        <copy>
                           
                            <xsl:attribute name="todir">@{destdir}</xsl:attribute>
                            <fileset>
                                <xsl:attribute name="dir">${build.dir}/mirah</xsl:attribute>
                                <xsl:attribute name="excludes">**/macros/**.mirah</xsl:attribute>
                            </fileset>
                        </copy>
                    </sequential>
                </macrodef>
                <macrodef>
                    <xsl:attribute name="name">depend</xsl:attribute>
                    <xsl:attribute name="uri">http://www.netbeans.org/ns/web-project/2</xsl:attribute>
                    <attribute>
                        <xsl:attribute name="name">srcdir</xsl:attribute>
                        <xsl:attribute name="default">
                            <xsl:call-template name="createPath">
                                <xsl:with-param name="roots" select="/p:project/p:configuration/webproject3:data/webproject3:source-roots"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </attribute>
                    <attribute>
                        <xsl:attribute name="name">destdir</xsl:attribute>
                        <xsl:attribute name="default">${build.classes.dir}</xsl:attribute>
                    </attribute>
                    <attribute>
                        <xsl:attribute name="name">classpath</xsl:attribute>
                        <xsl:attribute name="default">${javac.classpath}:${j2ee.platform.classpath}</xsl:attribute>
                    </attribute>
                    <sequential>
                        <depend>
                            <xsl:attribute name="srcdir">@{srcdir}</xsl:attribute>
                            <xsl:attribute name="destdir">@{destdir}</xsl:attribute>
                            <xsl:attribute name="cache">${build.dir}/depcache</xsl:attribute>
                            <xsl:attribute name="includes">${includes}</xsl:attribute>
                            <xsl:attribute name="excludes">${excludes}</xsl:attribute>
                            <classpath>
                                <path path="@{{classpath}}"/>
                            </classpath>
                        </depend>
                    </sequential>
                </macrodef>
                <macrodef>
                    <xsl:attribute name="name">force-recompile</xsl:attribute>
                    <xsl:attribute name="uri">http://www.netbeans.org/ns/web-project/2</xsl:attribute>
                    <attribute>
                        <xsl:attribute name="name">destdir</xsl:attribute>
                        <xsl:attribute name="default">${build.classes.dir}</xsl:attribute>
                    </attribute>
                    <sequential>
                        <fail unless="javac.includes">Must set javac.includes</fail>
                        <pathconvert>
                            <xsl:attribute name="property">javac.includes.binary</xsl:attribute>
                            <xsl:attribute name="pathsep">,</xsl:attribute>
                            <path>
                                <filelist>
                                    <xsl:attribute name="dir">@{destdir}</xsl:attribute>
                                    <xsl:attribute name="files">${javac.includes}</xsl:attribute>
                                </filelist>
                            </path>
                            <globmapper>
                                <xsl:attribute name="from">*.java</xsl:attribute>
                                <xsl:attribute name="to">*.class</xsl:attribute>
                            </globmapper>
                        </pathconvert>
                        <delete>
                            <files includes="${{javac.includes.binary}}"/>
                        </delete>
                    </sequential>
                </macrodef>
            </target>
           

            <!--                    -->
            <!--    Test project    -->
            <!--                    -->
            <target depends="init,compile-test,-pre-test-run" if="have.tests" name="-do-test-run-with-mirah">
                <webproject2:test testincludes=""/>
            </target>
            <target depends="init,compile-test,-pre-test-run,-do-test-run-with-mirah" if="have.tests" name="-post-test-run-with-mirah">
                <fail if="tests.failed" unless="ignore.failing.tests">Some tests failed; see details above.</fail>
            </target>
            <target depends="init,compile-test,-pre-test-run,-do-test-run-with-mirah,test-report,-post-test-run-with-mirah,-test-browse" description="Run unit tests." name="test-with-mirah"/>

            <!--                                        -->
            <!--    Single mirah file test runner      -->
            <!--                                        -->
            <target depends="init,compile-test-single,-pre-test-run-single" if="have.tests" name="-do-test-run-single-mirah">
                <fail unless="test.binarytestincludes">Must select some files in the IDE or set test.includes</fail>
                <webproject2:test testincludes=""/>
            </target>
            <target depends="init,compile-test-single,-pre-test-run-single,-do-test-run-single-mirah" if="have.tests" name="-post-test-run-single-mirah">
                <fail if="tests.failed" unless="ignore.failing.tests">Some tests failed; see details above.</fail>
            </target>
            <target depends="init,compile-test-single,-pre-test-run-single,-do-test-run-single-mirah,-post-test-run-single-mirah" description="Run single unit test." name="test-single-mirah"/>

            <!--                                             -->
            <!--    Single mirah file debug test runner     -->
            <!--                                             -->
            <target depends="init,compile-test-single,-pre-test-run-single,-debug-start-debugger-test" name="-do-test-debug-single-mirah">
                <fail unless="test.binarytestincludes">Must select some files in the IDE or set test.binarytestincludes</fail>
                <webproject2:test-debug testincludes="" />
            </target>
            <target depends="init,compile-test-single,-pre-test-run-single,-do-test-debug-single-mirah" if="have.tests" name="-post-test-debug-single-mirah">
                <fail if="tests.failed" unless="ignore.failing.tests">Some tests failed; see details above.</fail>
            </target>
            <target depends="init,compile-test-single,-pre-test-run-single,-debug-start-debugger-test,-do-test-debug-single-mirah,-post-test-debug-single-mirah" name="debug-single-mirah"/>

        </project>
    </xsl:template>

    <xsl:template name="createPath">
        <xsl:param name="roots"/>
        <xsl:for-each select="$roots/webproject3:root">
            <xsl:if test="position() != 1">
                <xsl:text>:</xsl:text>
            </xsl:if>
            <xsl:text>${</xsl:text>
            <xsl:value-of select="@id"/>
            <xsl:text>}</xsl:text>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>