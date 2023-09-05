--
-- turn_data_dissector.lua
-- dissector for the DATA attribute
-- Drop in the Personal Lua Plugins, Global Lua Plugins or Personal configuration folder (Help > About > Folders)
--

-------------------------------------------------------------------------------

do
        local d = require('debug')
        local t = Dissector.list()
        for _,name in ipairs(t) do
            print(name)
        end

        local stun_wrapper_proto = Proto("stun2", "Extra analysis of the STUN protocol");
        -- (to confirm this worked, check that this protocol appears at the bottom of the "Filter Expression" dialog)

        -- our new fields
        local F_newfield1 = ProtoField.uint16("http.newfield1", "Our new field, #1", base.DEC)
        local F_newfield2 = ProtoField.uint16("http.newfield2", "Our new field, #2", base.DEC)
        -- add the fields to the protocol
        -- (to confirm this worked, check that these fields appeared in the "Filter Expression" dialog)
        stun_wrapper_proto.fields = {F_newfield1, F_newfield2}

        -- declare the fields we need to read
        local f_attrs = Field.new("stun.attributes")
        local original_stun_dissector

        function stun_wrapper_proto.dissector(tvbuffer, pinfo, treeitem)
                -- we've replaced the original STUN dissector in the dissector table,
                -- but we still want the original to run, especially because we need to read its data
                original_stun_dissector:call(tvbuffer, pinfo, treeitem)

                print(d.traceback())

                --if f_set_cookie() then
                        -- this has two effects:
                        --      1. makes it so we can use "http_extra" as a display filter
                        --      2. displays a new header in the tree pane for our protocol
                        local subtreeitem = treeitem:add(stun_wrapper_proto, tvbuffer)
                        field1_val = 42
                        subtreeitem:add(F_newfield1, tvbuffer(), field1_val)
                                   :set_text("Don't panic: " .. field1_val)
                        -- (now "http.newfield1 == 42" should work as a display filter)
                        field2_val = 616
                        subtreeitem:add(F_newfield2, tvbuffer(), field2_val)
                                   :set_text("The REAL number of the beast: " .. field2_val)

                        -- 00 13 BE-len(2 bytes) data
                        Dissector.get("stun-heur"):call(buf(4):tvb(),  pinfo, tree)
                --end
        end

        local udp_dissector_table = DissectorTable.get("udp.port")
        original_stun_dissector = Dissector.get("classicstun-heur") -- save the original dissector so we can still get to it
        udp_dissector_table:add(3478, stun_wrapper_proto)                 -- and take its place in the dissector table
end

-------------------------------------------------------------------------------
