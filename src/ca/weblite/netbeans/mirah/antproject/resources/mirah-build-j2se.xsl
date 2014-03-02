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
                xmlns:j2seproject1="http://www.netbeans.org/ns/j2se-project/1"
                xmlns:j2seproject2="http://www.netbeans.org/ns/j2se-project/2"
                xmlns:j2seproject3="http://www.netbeans.org/ns/j2se-project/3"
                xmlns:jaxrpc="http://www.netbeans.org/ns/j2se-project/jax-rpc"
                xmlns:projdeps="http://www.netbeans.org/ns/ant-project-references/1"
                xmlns:projdeps2="http://www.netbeans.org/ns/ant-project-references/2"
                xmlns:libs="http://www.netbeans.org/ns/ant-project-libraries/1"
                exclude-result-prefixes="xalan p projdeps projdeps2 j2seproject2 libs">
    <!-- XXX should use namespaces for NB in-VM tasks from ant/browsetask and debuggerjpda/ant (Ant 1.6.1 and higher only) -->
    <xsl:output method="xml" indent="yes" encoding="UTF-8" xalan:indent-amount="4"/>
    <xsl:template match="/">

        <xsl:comment><![CDATA[
*** GENERATED FROM project.xml - DO NOT EDIT  ***
***         EDIT ../build.xml INSTEAD         ***

        ]]>
        </xsl:comment>

        <xsl:variable name="name" select="/p:project/p:configuration/j2seproject3:data/j2seproject3:name"/>
        <xsl:variable name="codename" select="translate($name, ' ', '_')"/>
        <project>
            <target name="-mirah-init-macrodef-javac">
                <macrodef>
                    <xsl:attribute name="name">javac</xsl:attribute>
                    <xsl:attribute name="uri">http://www.netbeans.org/ns/j2se-project/3</xsl:attribute>
                    <attribute>
                        <xsl:attribute name="name">srcdir</xsl:attribute>
                        <xsl:attribute name="default">
                            <xsl:call-template name="createPath">
                                <xsl:with-param name="roots" select="/p:project/p:configuration/j2seproject3:data/j2seproject3:source-roots"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </attribute>
                    <attribute>
                        <xsl:attribute name="name">destdir</xsl:attribute>
                        <xsl:attribute name="default">${build.classes.dir}</xsl:attribute>
                    </attribute>
                    <attribute>
                        <xsl:attribute name="name">classpath</xsl:attribute>
                        <xsl:attribute name="default">${javac.classpath}</xsl:attribute>
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
                            <xsl:attribute name="classpath">${libs.mirah-all.classpath}:${javac.classpath}</xsl:attribute>
                            <xsl:attribute name="classname">ca.weblite.mirah.ant.MirahcTask</xsl:attribute>
                        </taskdef>
                        <property name="empty.dir" location="${{build.dir}}/empty"/><!-- #157692 -->
                        <mkdir dir="${{empty.dir}}"/>
                        <mkdir>
                            <xsl:attribute name="dir">${build.dir}/mirah</xsl:attribute>
                        </mkdir>
                        <mirahc>
                            <xsl:attribute name="dest">${build.dir}/mirah</xsl:attribute>
                            <javac>
                                <xsl:attribute name="srcdir">@{srcdir}</xsl:attribute>
                                <xsl:attribute name="classpath">@{classpath}</xsl:attribute>
                                <xsl:attribute name="sourcepath">@{sourcepath}</xsl:attribute>
                                <xsl:attribute name="includes">@{includes}</xsl:attribute>
                                <xsl:attribute name="excludes">@{excludes}</xsl:attribute>
                                
                                
                                <xsl:attribute name="debug">@{debug}</xsl:attribute>
                                <xsl:attribute name="deprecation">${javac.deprecation}</xsl:attribute>
                                <xsl:attribute name="encoding">${source.encoding}</xsl:attribute>
                                <xsl:if test ="not(/p:project/p:configuration/j2seproject3:data/j2seproject3:explicit-platform/@explicit-source-supported ='false')">
                                    <xsl:attribute name="source">${javac.source}</xsl:attribute>
                                    <xsl:attribute name="target">${javac.target}</xsl:attribute>
                                </xsl:if>
                                <xsl:if test="/p:project/p:configuration/j2seproject3:data/j2seproject3:explicit-platform">
                                    <xsl:attribute name="fork">yes</xsl:attribute>
                                    <xsl:attribute name="executable">${platform.javac}</xsl:attribute>
                                    <xsl:attribute name="tempdir">${java.io.tmpdir}</xsl:attribute> <!-- XXX cf. #51482, Ant #29391 -->
                                </xsl:if>

                                <compilerarg line="${{javac.compilerargs}}"/>
                                <customize/>
                            </javac>
                        </mirahc>
                        <copy>
                            <xsl:attribute name="todir">@{destdir}</xsl:attribute>
                            <fileset>
                                <xsl:attribute name="dir">${build.dir}/mirah</xsl:attribute>
                            </fileset>
                        </copy>
                    </sequential>
                </macrodef>
                <macrodef> <!-- #36033, #85707 -->
                    <xsl:attribute name="name">depend</xsl:attribute>
                    <xsl:attribute name="uri">http://www.netbeans.org/ns/j2se-project/3</xsl:attribute>
                    <attribute>
                        <xsl:attribute name="name">srcdir</xsl:attribute>
                        <xsl:attribute name="default">
                            <xsl:call-template name="createPath">
                                <xsl:with-param name="roots" select="/p:project/p:configuration/j2seproject3:data/j2seproject3:source-roots"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </attribute>
                    <attribute>
                        <xsl:attribute name="name">destdir</xsl:attribute>
                        <xsl:attribute name="default">${build.classes.dir}</xsl:attribute>
                    </attribute>
                    <attribute>
                        <xsl:attribute name="name">classpath</xsl:attribute>
                        <xsl:attribute name="default">${javac.classpath}</xsl:attribute>
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
                <macrodef> <!-- #85707 -->
                    <xsl:attribute name="name">force-recompile</xsl:attribute>
                    <xsl:attribute name="uri">http://www.netbeans.org/ns/j2se-project/3</xsl:attribute>
                    <attribute>
                        <xsl:attribute name="name">destdir</xsl:attribute>
                        <xsl:attribute name="default">${build.classes.dir}</xsl:attribute>
                    </attribute>
                    <sequential>
                        <fail unless="javac.includes">Must set javac.includes</fail>
                        <!-- XXX one little flaw in this weird trick: does not work on folders. -->
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
                <j2seproject3:test testincludes=""/>
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
                <j2seproject3:test testincludes=""/>
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
                <j2seproject3:test-debug testincludes="" />
            </target>
            <target depends="init,compile-test-single,-pre-test-run-single,-do-test-debug-single-mirah" if="have.tests" name="-post-test-debug-single-mirah">
                <fail if="tests.failed" unless="ignore.failing.tests">Some tests failed; see details above.</fail>
            </target>
            <target depends="init,compile-test-single,-pre-test-run-single,-debug-start-debugger-test,-do-test-debug-single-mirah,-post-test-debug-single-mirah" name="debug-test-with-mirah"/>
        </project>
    </xsl:template>

    <xsl:template name="createPath">
        <xsl:param name="roots"/>
        <xsl:for-each select="$roots/j2seproject3:root">
            <xsl:if test="position() != 1">
                <xsl:text>:</xsl:text>
            </xsl:if>
            <xsl:text>${</xsl:text>
            <xsl:value-of select="@id"/>
            <xsl:text>}</xsl:text>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>