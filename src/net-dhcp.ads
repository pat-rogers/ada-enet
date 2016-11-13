-----------------------------------------------------------------------
--  net-dhcp -- DHCP client
--  Copyright (C) 2016 Stephane Carrez
--  Written by Stephane Carrez (Stephane.Carrez@gmail.com)
--
--  Licensed under the Apache License, Version 2.0 (the "License");
--  you may not use this file except in compliance with the License.
--  You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
--  Unless required by applicable law or agreed to in writing, software
--  distributed under the License is distributed on an "AS IS" BASIS,
--  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--  See the License for the specific language governing permissions and
--  limitations under the License.
-----------------------------------------------------------------------
with Net.Headers;
with Ada.Real_Time;
with Net.Interfaces;
with Net.Buffers;
with Net.Sockets.Udp;
package Net.DHCP is

   --  The <tt>State_Type</tt> defines the DHCP client finite state machine.
   type State_Type is (STATE_INIT, STATE_INIT_REBOOT, STATE_SELECTING, STATE_REQUESTING,
                       STATE_BOUND, STATE_RENEWING, STATE_REBINDING,
                       STATE_REBOOTING);

   type Client is new Net.Sockets.Udp.Socket with private;

   --  Get the current DHCP client state.
   function Get_State (Request : in Client) return State_Type;

   --  Send the DHCP discover packet to initiate the DHCP discovery process.
   procedure Discover (Request : in out Client;
                       Ifnet   : access Net.Interfaces.Ifnet_Type'Class);

   overriding
   procedure Receive (Request  : in out Client;
                      From     : in Net.Sockets.Sockaddr_In;
                      Packet   : in out Net.Buffers.Buffer_Type);

private

   type Client is new Net.Sockets.Udp.Socket with record
      State     : State_Type := STATE_INIT;
      Xid       : Net.Uint32;
      Secs      : Net.Uint16 := 0;
      Ip        : Net.Ip_Addr := (others => 0);
      Server_Ip : Net.Ip_Addr := (others => 0);
   end record;

end Net.DHCP;