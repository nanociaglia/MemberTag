#include <sourcemod>
#include <chat-processor>
#include <SWGM>

char g_cChatPrefix[20];
ConVar g_cvarMemberPrefix;

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "MemberPrefix",
	author = "Nano",
	description = "Gives a custom chat prefix for those who are in steam group.",
	version = "1.0",
	url = "https://steamcommunity.com/id/marianzet1/"
};

public void OnPluginStart()
{
	g_cvarMemberPrefix = CreateConVar("sm_member_prefix", "[MEMBER]", "Prefix for those who are in steam group");
}

public void OnMapStart()
{
	g_cvarMemberPrefix.GetString(g_cChatPrefix, sizeof(g_cChatPrefix));
}

public Action CP_OnChatMessage(int& author, ArrayList recipients, char[] flagstring, char[] name, char[] message, bool & processcolors, bool & removecolors)
{
	if(IsClientInGame(author) && SWGM_IsPlayerValidated(author) && SWGM_InGroup(author))
	{
		if(!CheckCommandAccess(author, "sm_antiprefix_override", ADMFLAG_BAN))
		{
			char sTag[40];
			Format(sTag, sizeof(sTag), "\x04%s\x03", g_cChatPrefix);
			
			Format(name, MAXLENGTH_MESSAGE, " %s %s", sTag, name);
			return Plugin_Changed;
		}
	}

	return Plugin_Continue;
}