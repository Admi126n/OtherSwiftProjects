//
//  CMSampleBuffer+isKeyFrame.swift
//  Client
//
//  Created by Adam Tokarski on 05/11/2023.
//

import VideoToolbox

extension CMSampleBuffer {
	var isKeyFrame: Bool {
		let attachments = CMSampleBufferGetSampleAttachmentsArray(self, createIfNecessary: true) as? [[CFString: Any]]
		
		let isNotKeyFrame = (attachments?.first?[kCMSampleAttachmentKey_NotSync] as? Bool) ?? false
		
		return !isNotKeyFrame
	}
}
