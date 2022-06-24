<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output omit-xml-declaration="yes" indent="yes"/>
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/domain/devices">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
            %{ for device in pci_devices }
            <xsl:element name ="hostdev">
                <xsl:attribute name="mode">subsystem</xsl:attribute>
                <xsl:attribute name="type">pci</xsl:attribute>
                <xsl:attribute name="managed">yes</xsl:attribute>
                <xsl:element name="driver">
                    <xsl:attribute name="name">vfio</xsl:attribute>
                </xsl:element>
                <xsl:element name="source">
                    <xsl:element name="address">
                        <xsl:attribute name="domain">0x0000</xsl:attribute>
                        <xsl:attribute name="bus">${device.host.bus}</xsl:attribute>
                        <xsl:attribute name="slot">${device.host.slot}</xsl:attribute>
                        <xsl:attribute name="function">0x0</xsl:attribute>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="alias">
                    <xsl:attribute name="name">${device.name}</xsl:attribute>
                </xsl:element>
                <xsl:element name="address">
                    <xsl:attribute name="type">pci</xsl:attribute>
                    <xsl:attribute name="domain">0x0000</xsl:attribute>
                    <xsl:attribute name="bus">${device.guest.bus}</xsl:attribute>
                    <xsl:attribute name="slot">${device.guest.slot}</xsl:attribute>
                    <xsl:attribute name="function">0x0</xsl:attribute>
                </xsl:element>
            </xsl:element>
            %{ endfor }

            %{ for device in usb_devices }
            <xsl:element name ="hostdev">
                <xsl:attribute name="mode">subsystem</xsl:attribute>
                <xsl:attribute name="type">usb</xsl:attribute>
                <xsl:attribute name="managed">yes</xsl:attribute>
                <xsl:element name="source">
                    <xsl:element name="vendor">
                        <xsl:attribute name="id">${device.vendor}</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="product">
                        <xsl:attribute name="id">${device.product}</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="address">
                        <xsl:attribute name="bus">${device.host.bus}</xsl:attribute>
                        <xsl:attribute name="device">${device.host.device}</xsl:attribute>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="alias">
                    <xsl:attribute name="name">${device.name}</xsl:attribute>
                </xsl:element>
                <xsl:element name="address">
                    <xsl:attribute name="type">usb</xsl:attribute>
                    <xsl:attribute name="bus">${device.guest.bus}</xsl:attribute>
                    <xsl:attribute name="port">${device.guest.port}</xsl:attribute>
                </xsl:element>
            </xsl:element>
            %{ endfor }
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
