#import "XMPPStringPrep.h"
#import "stringprep.h"


@implementation XMPPStringPrep

/**
 *  将传入的用户名转化为UTF-8编码的字符串
 *
 *  @param node 用户名
 *
 *  @return UTF-8编码的用户名
 */
+ (NSString *)prepNode:(NSString *)node
{
	if(node == nil) return nil;
	
	// Each allowable portion of a JID MUST NOT be more than 1023 bytes in length.
	// We make the buffer just big enough to hold a null-terminated string of this length. 
	char buf[1024];
	
	strncpy(buf, [node UTF8String], sizeof(buf));
	
	if(stringprep_xmpp_nodeprep(buf, sizeof(buf)) != 0) return nil;
	
	return [NSString stringWithUTF8String:buf];
}

/**
 *  将传入的domain转化为UTF-8编码的字符串
 *
 *  @param domain domain
 *
 *  @return UTF-8编码的domain
 */
+ (NSString *)prepDomain:(NSString *)domain
{
	if(domain == nil) return nil;
	
	// Each allowable portion of a JID MUST NOT be more than 1023 bytes in length.
	// We make the buffer just big enough to hold a null-terminated string of this length. 
	char buf[1024];
	
	strncpy(buf, [domain UTF8String], sizeof(buf));
	
	if(stringprep_nameprep(buf, sizeof(buf)) != 0) return nil;
	
	return [NSString stringWithUTF8String:buf];
}

/**
 *  将传入的resource转化为UTF-8编码的字符串
 *
 *  @param resource resource名
 *
 *  @return UTF-8编码的resource
 */
+ (NSString *)prepResource:(NSString *)resource
{
	if(resource == nil) return nil;
	
	// Each allowable portion of a JID MUST NOT be more than 1023 bytes in length.
	// We make the buffer just big enough to hold a null-terminated string of this length. 
	char buf[1024];
	
	strncpy(buf, [resource UTF8String], sizeof(buf));
	
	if(stringprep_xmpp_resourceprep(buf, sizeof(buf)) != 0) return nil;
	
	return [NSString stringWithUTF8String:buf];
}

@end
