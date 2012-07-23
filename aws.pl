#-------------------------------------------------------------------------
#
# aws.pl
#
#-------------------------------------------------------------------------
# www.QuestorSystems.com              -:-     developer@QuestorSystems.com
#-------------------------------------------------------------------------
#
# aws.pl: whatever
#
# Project:	
# Author:	Farley Balasuriya (developer@QuestorSystems.com)
# Created:	2011-12-11T02:17:31
# History:
#		v0.2 - 
#		v0.1 - 2011-12-11 - initial version created
#            
#-------------------------------------------------------------------------
$svn_rev='$Rev: 110 $';
$svn_id='$Id: tapp.pl 110 2005-04-25 02:40:51Z farley $';
$svn_LastChangedDate='$LastChangedDate: 2005-04-25 04:40:51 +0200 (Mon, 25 Apr 2005) $';
#-------------------------------------------------------------------------
# (c)1997 - 2011, QuestorSystems.com, All rights reserved.
# Gempenstrasse 46, CH-4053, Basel, Switzerland
# telephone:+41 79 285 6482,  email:developer@QuestorSystems.com
#-------------------------------------------------------------------------

#!/usr/bin/perl
#
# Copyright 2007-2010 Timothy Kay
# http://timkay.com/aws/
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#


$program_version = "1.75";
$ec2_version = "2010-11-15";
$sqs_version = "2009-02-01";
$elb_version = "2010-07-01";
$sdb_version = "2009-04-15";
$iam_version = "2010-05-08";


#
# Need to implement:
#
#   ConfirmProductInstance - not tested
#   DescribeImageAttribute - not working "An internal error has occurred"
#   ModifyImageAttribute
#   ResetImageAttribute
#
# Windows support:
#   BundleInstance
#   DescribeBundleTasks
#   CancelBundleTasks
#

@cmd = (
	["ec2", "add-group addgrp", CreateSecurityGroup, [
							  ["", GroupName],
							  ["d", GroupDescription],
							  ]],
	["ec2", "add-keypair addkey", CreateKeyPair, [["", KeyName]]],
	["ec2", "allocate-address allad", AllocateAddress],
	["ec2", "associate-address aad", AssociateAddress, [
								["", PublicIp],
								["i", InstanceId],
								]],
	["ec2", "attach-volume attvol", AttachVolume, [
						       ["", VolumeId],
						       ["i", InstanceId],
						       ["d", Device],
						       ]],
	["ec2", "authorize auth", AuthorizeSecurityGroupIngress, [
								  ["" => GroupName],
								  ["protocol P" => "IpPermissions.1.IpProtocol"],
								  [p => undef, undef, sub {
								      my($min, $max) = split(/-/, $_[0]."-".$_[0]);
								      ["IpPermissions.1.FromPort" => $min, "IpPermissions.1.ToPort" => $max];
								  }],
								  [q => "IpPermissions.1.ToPort"],
								  #["t", icmp type code],
								  ["source-group-user u" => "IpPermissions.1.Groups.N.UserId"],
								  ["source-group o" => "IpPermissions.1.Groups.N.GroupName"],
								  ["s" => "IpPermissions.1.IpRanges.N.CidrIp"],
								  ]],
	["ec2", "create-image cimg", CreateImage, [
                                                   ["", InstanceId],
                                                   ["n", Name],
                                                   ["d", Description, ""],
                                                   ["no-reboot", NoReboot, false],
                                                   ]],
	["ec2", "cancel-spot-instance-requests cancel csir", CancelSpotInstanceRequests, [
									   ["", SpotInstanceRequestIdN],
									   ]],								  
	["ec2", "confirm-product-instance", ConfirmProductInstance, [
								     ["", ProductCode],
								     ["i", InstanceId],
								     ]],
	["ec2", "create-snapshot csnap", CreateSnapshot, [
							  ["", VolumeId],
							  ["description", Description],
							  ]],
	["ec2", "describe-spot-instance-requests dsir", DescribeSpotInstanceRequests, [
										       ["", SpotInstanceRequestIdN],
										       ]],
	["ec2", "describe-spot-price-history dsph", DescribeSpotPriceHistory, [
									       ["start", StartTime],
									       ["end", EndTime],
									       ["instance-type", InstanceType, "m1.small"],
									       ["description", ProductDescription, "Linux/UNIX"],
									       ]],									   
	["ec2", "create-volume cvol", CreateVolume, [
						     ["size", Size],
						     ["zone", AvailabilityZone],
						     ["snapshot", SnapshotId],
						     ]],
	["ec2", "delete-group delgrp", DeleteSecurityGroup, [["", GroupName]]],
	["ec2", "delete-keypair delkey", DeleteKeyPair, [["", KeyName]]],
	["ec2", "delete-snapshot delsnap", DeleteSnapshot, [["", SnapshotId]]],
	["ec2", "delete-volume delvol", DeleteVolume, [["", VolumeId]]],
	["ec2", "deregister", DeregisterImage, [["", ImageId]]],
	["ec2", "describe-addresses dad", DescribeAddresses, [["", PublicIpN]]],
	["ec2", "describe-availability-zones daz", DescribeAvailabilityZones, [["", ZoneNameN]]],
	["ec2", "describe-groups dgrp", DescribeSecurityGroups, [["", GroupNameN]]],
	["ec2", "describe-image-attribute", DescribeImageAttribute, [
								       ["", ImageId],
								       ["l", launchPermission],
								       ["p", productCodes],
								       ["kernel", "kernel"],
								       ["ramdisk", "ramdisk"],
								       ["B", "blockDeviceMapping"],
								       ]],
	["ec2", "describe-images dim", DescribeImages, [
							["", ImageIdN],
							["o", OwnerN],
							["x", ExecutableByN],
							]],
	["ec2", "describe-instances din", DescribeInstances, [["", InstanceIdN]]],
	["ec2", "describe-keypairs dkey", DescribeKeyPairs, [["", KeyNameN]]],
	["ec2", "describe-regions dreg", DescribeRegions],
	["ec2", "describe-reserved-instances", DescribeReservedInstances, [
									   ["", ReservedInstanceIdN],
									   ]],
	["ec2", "describe-reserved-instances-offerings", DescribeReservedInstancesOfferings, [
											      ["offering", ReservedInstancesOfferingIdN],
											      ["instance-type", InstanceType],
											      ["availability-zone", AvailabilityZone],
											      ["z", AvailabilityZone],
											      ["description", ProductDescription],
											      ]],
	["ec2", "describe-snapshot-attribute dsa", DescribeSnapshotAttribute, [
									       ["", SnapshotIdN],
									       ["attribute", Attribute],
									       ]],
	["ec2", "reset-snapshot-attribute rsa", ResetSnapshotAttribute, [
									 ["", SnapshotIdN],
									 ["attribute", Attribute],
									 ]],
	["ec2", "modify-snapshot-attribute msa", ModifySnapshotAttribute, [
									   ["", SnapshotId],
									   ["user", UserId],
									   ["group", UserGroup],
									   ["attribute", Attribute],
									   ["type", OperationType],
									   ]],
	["ec2", "describe-snapshots dsnap", DescribeSnapshots, [
								["", SnapshotIdN],
								["owner", Owner, "self"],
								["restorableby", RestorableBy],
								]],
	["ec2", "describe-volumes dvol", DescribeVolumes, [["", VolumeIdN]]],
	["ec2", "detach-volume detvol", DetachVolume, [["", VolumeId]]],
	["ec2", "disassociate-address disad", DisassociateAddress, [["", PublicIp]]],
	["ec2", "get-console-output gco", GetConsoleOutput, [["", InstanceId]]],
	["ec2", "purchase-reserved-instance-offering", PurchaseReservedInstancesOffering, [
											  ["offering-id", ReservedInstancesOfferingId],
											  ["instance-count", InstanceCount],
											  ]],
	["ec2", "reboot-instances reboot", RebootInstances, [["", InstanceIdN]]],
	["ec2", "release-address rad", ReleaseAddress, [["", PublicIp]]],
	["ec2", "register-image register", RegisterImage, [["", ImageLocation],
							   ["name n" => Name],
							   ["description d" => Description],
							   ["architecture a" => Architecture],
							   [kernel => KernelId],
							   [ramdisk => RamdiskId],
							   ["root-device-name" => RootDeviceName, "/dev/sda1"],
							   ["block-device-mapping b", undef, undef, \&parse_block_device_mapping],
							   ["device-name" => "BlockDeviceMapping.N.DeviceName"],
							   ["no-device" => "BlockDeviceMapping.N.Ebs.NoDevice"],
							   ["virtual-name" => "BlockDeviceMapping.N.VirtualName"],
							   [snapshot => "BlockDeviceMapping.N.Ebs.SnapshotId"],
							   ["volume-size" => "BlockDeviceMapping.N.Ebs.VolumeSize"],
							   ["delete-on-termination" => "BlockDeviceMapping.N.Ebs.DeleteOnTermination"],
							   ]],
	["ec2", "request-spot-instances req-spot rsi", RequestSpotInstances, [
									      ["" => "LaunchSpecification.ImageId", "ami-4a0df923"],
									      ["price p" => SpotPrice],
									      ["instance-count n" => InstanceCount, 1],
									      ["type r" => Type, "one-time"],
									      ["valid-from-date" => ValidFrom],
									      ["valid-until-date" => ValidUntil],
									      ["launch-group" => LaunchGroup],
									      ["availability-zone-group" => AvailabilityZoneGroup],
									      ["user-data d" => "LaunchSpecification.UserData", undef,
									       sub {encode_base64($_[0], "")}],
									      ["user-data-file f" => "LaunchSpecification.UserData", undef,
									       sub {encode_base64(load_file($_[0]))}],
									      ["group g" => "LaunchSpecification.SecurityGroupN", "default"],
									      ["a", "LaunchSpecification.AddressingType"],
									      ["key k" => "LaunchSpecification.KeyName"],
									      ["instance-type t" => "LaunchSpecification.InstanceType", "t1.micro"],
									      ["availability-zone z" => "LaunchSpecification.Placement.AvailabilityZone"],
									      [kernel => "LaunchSpecification.KernelId"],
									      [ramdisk => "LaunchSpecification.RamdiskId"],
									      [subnet => "LaunchSpecification.SubnetId"],
									      ["block-device-mapping b" => "LaunchSpecification.blockDeviceMapping.N.DeviceName"],
									      [monitor => "LaunchSpecification.Monitoring.Enabled"],
								 ]],
	["ec2", "revoke", RevokeSecurityGroupIngress, [
						       ["" => GroupName],
						       ["protocol P" => "IpPermissions.1.IpProtocol"],
						       ["p" => undef, undef, sub
							{
							    my($min, $max) = split(/-/, $_[0]."-".$_[0]);
							    ["IpPermissions.1.FromPort" => $min, "IpPermissions.1.ToPort" => $max];
							}],
						       ["q", "IpPermissions.1.ToPort"],
						       #["t", icmp type code],
						       ["source-group-user u" => "IpPermissions.1.Groups.N.UserId"],
						       ["source-group o" => "IpPermissions.1.Groups.N.GroupName"],
						       ["s" => "IpPermissions.1.IpRanges.N.CidrIp"],
						       ]],
	["ec2", "run-instances run-instance run", RunInstances, [
								 ["", ImageId],
								 ["instance-count n", undef, 1, sub
								  {
								      my($min, $max) = split(/-/, $_[0]."-".$_[0]);
								      [MinCount => $min, MaxCount => $max];
								  }],
								 ["group g", SecurityGroupN, "default"],
								 ["key k", KeyName],
								 ["user-data d", UserData, undef, sub {encode_base64($_[0], "")}],
								 ["user-data-file f", UserData, undef, sub {encode_base64(load_file($_[0]))}],
								 ["a", AddressingType],
								 ["instance-type type t i", InstanceType],
								 ["availability-zone z", "Placement.AvailabilityZone"],
								 ["kernel", KernelId],
								 ["ramdisk", RamdiskId],
								 ["block-device-mapping b", undef, undef, \&parse_block_device_mapping],
								 ["device-name" => "BlockDeviceMapping.N.DeviceName"],
								 ["no-device" => "BlockDeviceMapping.N.Ebs.NoDevice"],
								 ["virtual-name" => "BlockDeviceMapping.N.VirtualName"],
								 ["snapshot s" => "BlockDeviceMapping.N.Ebs.SnapshotId"],
								 ["volume-size" => "BlockDeviceMapping.N.Ebs.VolumeSize"],
								 ["delete-on-termination" => "BlockDeviceMapping.N.Ebs.DeleteOnTermination"],
								 ["monitor m" => "Monitoring.Enabled"],
								 ["disable-api-termination" => DisableApiTermination],
								 ["instance-initiated-shutdown-behavior" => InstanceInitiatedShutdownBehavior],
								 ["placement-group" => "Placement.GroupName"],
								 ["subnet s" => SubnetId],
								 ["private-ip-address" => PrivateIpAddress],
								 ["client-token" => ClientToken],
								 ]],
        ["ec2", "start-instances start", StartInstances, [["", InstanceIdN]]],
        ["ec2", "stop-instances stop", StopInstances, [["", InstanceIdN]]],
	["ec2", "terminate-instances tin", TerminateInstances, [["", InstanceIdN]]],
	["ec2", "create-tags ctags", CreateTags, [
						  ["" => "ResourceIdN"],
						  ["tag", undef, undef, \&parse_tags],
						  ]],
	["ec2", "describe-tags dtags", DescribeTags, [
						      ["filter", undef, undef, \&parse_tags_describe],
						      ]],
	["ec2", "delete-tags deltags", DeleteTags, [
						    ["" => ResourceIdN],
						    ["tag", undef, undef, \&parse_tags_delete],
						    ]],

	#############
	###  ELB  ###
	#############

	["elb", "configure-healthcheck ch", ConfigureHealthCheck, [
								   ["", LoadBalancerName],
								   ["target", "HealthCheck.Target"],
								   ["healthy-threshold", "HealthCheck.HealthyThreshold"],
								   ["unhealthy-threshold", "HealthCheck.UnhealthyThreshold"],
								   ["interval", "HealthCheck.Interval"],
								   ["timeout", "HealthCheck.Timeout"],
								   ]],
	["elb", "create-app-cookie-stickiness-policy cacsp", CreateAppCookieStickinessPolicy, [
											       ["", LoadBalancerName],
											       ["policy-name", PolicyName],
											       ["cookie-name", CookieName],
											       ]],
	["elb", "create-lb-cookie-stickiness-policy clbcsp", CreateLBCookieStickinessPolicy, [
											      ["", LoadBalancerName],
											      ["policy-name", PolicyName],
											      ["expiration-period", "policy-name", PolicyName],
											      ]],
	["elb", "create-lb clb", CreateLoadBalancer, [
						      ["", LoadBalancerName],
						      ["availability-zone", "AvailabilityZones.memberN"],
						      ["protocol", "Listeners.member.1.Protocol"],
						      ["loadbalancerport", "Listeners.member.1.LoadBalancerPort"],
						      ["instanceport", "Listeners.member.1.InstancePort"],
						      ]],
	["elb", "create-lb-listeners clbl", CreateLoadBalancerListeners, [
								     ["", LoadBalancerName],
								     ["listener", "Listeners.memberN"],
								     ]],
	["elb", "delete-lb dellb", DeleteLoadBalancer, [
						  ["", LoadBalancerName],
						  ]],
	["elb", "delete-lb-listeners dlbl", DeleteLoadBalancerListeners, [
								     ["", LoadBalancerName],
								     ]],
	["elb", "delete-lb-policy dlbp", DeleteLoadBalancerPolicy, [
								    ["", LoadBalancerName],
								    ["policy-name", PolicyName],
								    ]],
	["elb", "describe-instance-health dih", DescribeInstanceHealth, [
								     ["", LoadBalancerName],
								     ["listener", "Listeners.memberN"],
								     ]],
	["elb", "describe-lbs dlb", DescribeLoadBalancers, [
							    ["", LoadBalancerNameN],
							    ]],
	["elb", "disable-zones-for-lb dlbz", DisableAvailabilityZonesForLoadBalancer, [
										       ["", LoadBalancerName],
										       ["availability-zone", "AvailabilityZones.memberN"],
										       ]],
	["elb", "enable-zones-for-lb elbz", EnableAvailabilityZonesForLoadBalancer, [
										     ["", LoadBalancerName],
										     ["availability-zone", "AvailabilityZones.memberN"],
										     ]],
	["elb", "register-instances-with-lb rlbi", RegisterInstancesWithLoadBalancer, [
										       ["", LoadBalancerName],
										       ["instance", "Instances.member.N.InstanceId"],
										       ]],
	["elb", "deregister-instances-from-lb dlbi", DeregisterInstancesFromLoadBalancer, [
											   ["", LoadBalancerName],
											   ["instance", "Instances.member.N.InstanceId"],
											   ]],
	["elb", "set-lb-listener-ssl-cert slblsc", SetLoadBalancerListenerSSLCertificate, [
										    ["", LoadBalancerName],
										    ["lb-port", LoadBalancerPort],
										    ["cert-id", SSLCertificateId],
										    ]],
	["elb", "set-lb-policies-of-listener slbpol", SetLoadBalancerPoliciesOfListener, [
											  ["", LoadBalancerName],
											  ["policy-name", "PolicyNames.memberN"],
											  ]],

	#############
	###  IAM  ###
	#############

	["iam", "groupaddpolicy pgp", PutGroupPolicy, [
						   [" g" => GroupName],
						   [p => PolicyName],
						   [e, undef, undef, \&parse_addpolicy_effect],
						   [a, undef, undef, \&parse_addpolicy_action],
						   [r, undef, undef, \&parse_addpolicy_resource],
						   [o, undef, undef, \&parse_addpolicy_output],
						   ]],
	["iam", "groupadduser", AddUserToGroup, [
						 [" g" => GroupName],
						 [u => UserName],
						 ]],
	["iam", "groupcreate cg", CreateGroup, [
					     [" g" => GroupName],
					     [p => Path],
					     ]],
	["iam", "groupdel", DeleteGroup, [
					  [" g" => GroupName],
					  ]],
	["iam", "groupdelpolicy", DeleteGroupPolicy, [
						      [" g" => GroupName],
						      [p => PolicyName],
						      ]],
	["iam", "grouplistbypath lg", ListGroups],
	["iam", "grouplistpolicies lgp", ListGroupPolicies, [
							     [" g" => GroupName],
							     [p => PolicyName],
							     ]],
	# GetGroupPolicy is automatically invoked when grouplistpolicies has a -p PolicyName
	["iam", "groupgetpolicy", GetGroupPolicy, [
						   [" g" => GroupName],
						   [p => PolicyName],
						   ]],
	["iam", "grouplistusers gg", GetGroup, [
						[" g" => GroupName],
						]],
	["iam", "groupmod", UpdateGroup, [
					  [" g" => GroupName],
					  [n => NewGroupName],
					  [p => NewPath],
					  ]],
	["iam", "groupremoveuser", RemoveUserFromGroup, [
							 [" g" => GroupName],
							 [u => UserName],
							 ]],
	["iam", "groupuploadpolicy", PutGroupPolicy, [
						      [" g" => GroupName],
						      [p => PolicyName],
						      [o => PolicyDocument],
						      [f => PolicyDocument, undef, sub {load_file($_[0])}],
						      ]],
	["iam", "useraddcert", UploadSigningCertificate, [
							  [" u" => UserName],
							  [c => CertificateBody],
							  [f => CertificateBody, undef, sub {load_file($_[0])}],
							  ]],
	["iam", "useraddkey cak", CreateAccessKey, [
						    [" u" => UserName],
						    ]],
	["iam", "useraddloginprofile clp", CreateLoginProfile, [
							    [" u" => UserName],
							    [p => Password],
							    ]],
	["iam", "useraddpolicy pup", PutUserPolicy, [
						     [" u" => UserName],
						     [p => PolicyName],
						     [e, undef, undef, \&parse_addpolicy_effect],
						     [a, undef, undef, \&parse_addpolicy_action],
						     [r, undef, undef, \&parse_addpolicy_resource],
						     [o, undef, undef, \&parse_addpolicy_output],
						     ]],
	["iam", "usercreate cu", CreateUser, [
					      [" u" => UserName],
					      [p => Path],
					      ]],
	["iam", "userdeactivatemfadevice", DeactivateMFADevice, [
								 [" u" => UserName],
								 [s => SerialNumber],
								 ]],
	["iam", "userdel", DeleteUser, [
					[" u" => UserName],
					[s => XXX],
					]],
	["iam", "userdelcert", DeleteSigningCertificate, [
							  [" u" => UserName],
							  [c => CertificateId],
							  ]],
	["iam", "userdelkey", DeleteAccessKey, [
						[" u" => UserName],
						[k => AccessKeyId],
						]],
	["iam", "userdelloginprofile dlp", DeleteLoginProfile, [
							    [" u" => UserName],
							    ]],
	["iam", "userdelpolicy", DeleteUserPolicy, [
						    [" u" => UserName],
						    [p => PolicyName],
						    ]],
	["iam", "userenablemfadevice", EnableMFADevice, [
							 [" u" => UserName],
							 [s => SerialNumber],
							 [c1 => AuthenticationCode1],
							 [c2 => AuthenticationCode2],
							 ]],
	["iam", "usergetattributes gu", GetUser, [
						  [" u" => UserName],
						  ]],
	["iam", "usergetloginprofile glp", GetLoginProfile, [
							 [" u" => UserName],
							 ]],
	["iam", "userlistbypath lu", ListUsers, [
						 [" p" => PathPrefix],
						 ]],
	["iam", "userlistcerts", ListSigningCertificates, [
							   [" u" => UserName],
							   ]],
	["iam", "userlistgroups", ListGroupsForUser, [
						      [" u" => Username],
						      ]],
	["iam", "userlistkeys", ListAccessKeys, [
						 [" u" => UserName],
						 ]],
	["iam", "userlistmfadevices", ListMFADevices, [
						       [" u" => UserName],
						       ]],
	["iam", "userlistpolicies lup", ListUserPolicies, [
						       [" u" => UserName],
						       [p => PolicyName],
						       ]],
	# GetUserPolicy is automatically invoked when userlistpolicies has a -p PolicyName
	["iam", "usergetpolicy", GetUserPolicy, [
				       [" u" => UserName],
				       [p => PolicyName],
				       ]],
	["iam", "usermod", UpdateUser, [
					[" u" => UserName],
					[n => NewUserName],
					[p => NewPath],
					]],
	["iam", "usermodcert", UpdateSigningCertificate, [
							  [" u" => UserName],
							  [c => CertificateId],
							  [s => Status],
							  ]],
	["iam", "usermodkey", UpdateAccessKey, [
						[" u" => UserName],
						[a => AccessKeyId],
						[s => Status],
						]],
	["iam", "usermodloginprofile ulp", UpdateLoginProfile, [
							    [" u" => UserName],
							    [p => Password],
							    ]],
	["iam", "userresyncmfadevice", ResyncMFADevice, [
							 [" u" => UserName],
							 [s => SerialNumber],
							 [c1 => AuthenticationCode1],
							 [c2 => AuthenticationCode2],
							 ]],
	["iam", "useruploadpolicy", PutUserPolicy, [
						    [" u" => UserName],
						    [p => PolicyName],
						    [o => PolicyDocument],
						    [f => PolicyDocument, undef, sub {load_file($_[0])}],
						    ]],
	["iam", "servercertdel", DeleteServerCertificate, [
							   [" s" => ServerCertificateName],
							   ]],
	["iam", "servercertgetattributes", GetServerCertificate, [
								  [" s" => ServerCertificate],
								  ]],
	["iam", "servercertlistbypath", ListServerCertificates, [
								 [" p" => PathPrefix],
								 ]],
	["iam", "servercertmod", UpdateServerCertificate, [
							   [" p" => NewPath],
							   [s => ServerCertificateName],
							   [n => NewServerCertificateName],
							   ]],
	["iam", "servercertupload", UploadServerCertificate, [
							      [" s" => ServerCertificateName],
							      [p => Path],
							      [b => CertificateBody, undef, sub {load_file($_[0])}],
							      [k => PrivateKey, undef, sub {load_file($_[0])}],
							      [c => CertificateChain, undef, sub {load_file($_[0])}],
							      ]],
	["iam", "accountaliascreate caa", CreateAccountAlias,[
							      ["" => AccountAlias],
							      ]],
	["iam", "accountaliasdelete daa", DeleteAccountAlias,[
							      ["" => AccountAlias],
							      ]],
	["iam", "accountaliaslist laa", ListAccountAliases],

	["s3", "ls", LS],
	["s3", "get cat", GET],
	["s3", "head", HEAD],
	["s3", "mkdir", MKDIR],
	["s3", "put", PUT],
	["s3", "delete rmdir rm", DELETE],
	["s3", "copy cp", COPY],

	["sqs", "add-permission addperm", AddPermission, [
							  ["" => QueueUri],
							  [label => Label],
							  [account => AWSAccountIdN],
							  [action => ActionNameN],
							  ]],

	["sqs", "change-message-visibility cmv", ChangeMessageVisibility, [
									   ["" => QueueUri],
									   [handle => ReceiptHandle],
									   [timeout => VisibilityTimeout],
									   ]],

	["sqs", "create-queue cq", CreateQueue, [
						 ["" => QueueName],
						 [timeout => DefaultVisibilityTimeout],
						 ]],

	["sqs", "delete-message dm", DeleteMessage, [
						     ["" => QueueUri],
						     [handle => ReceiptHandle],
						     ]],

	["sqs", "delete-queue dq", DeleteQueue, [
						 ["" => QueueUri],
						 ]],

	["sqs", "get-queue-attributes gqa", GetQueueAttributes, [
							["" => QueueUri],
							[attribute => AttributeNameN],
							]],

	["sqs", "list-queues lq", ListQueues, [
						 ["" => QueueNamePrefix],
						 ]],

	["sqs", "receive-message recv", ReceiveMessage, [
							 ["" => QueueUri],
							 [attribute => AttributeNameN],
							 [n => MaxNumberOfMessages],
							 [timeout => VisibilityTimeout],
							 ]],

	["sqs", "remove-permission remperm", RemovePermission, [
								["" => QueueUri],
								[label => Label],
								]],

	["sqs", "send-message send", SendMessage, [
						   ["" => QueueUri],
						   [message => MessageBody, "", sub {encode_url($_[0])}],
						   ]],

	["sqs", "set-queue-attributes sqa", SetQueueAttributes, [
								 ["" => QueueUri],
								 [attribute => "Attribute.Name"],
								 [value => "Attribute.Value"],
								 ]],

	["sdb", "create-domain cdom", CreateDomain, [
						     ["" => DomainName],
						     ]],
	["sdb", "delete-attributes datt", DeleteAttributes, [
							     ["" => DomainName],
							     [i => ItemName],
							     [n => "Attribute.N.Name"],
							     [v => "Attribute.N.Value"],
							     [xn => "Expected.N.Name"],
							     [xv => "Expected.N.Value"],
							     [exists => "Expected.N.Exists"],
							     ]],
	["sdb", "delete-domain ddom", DeleteDomain, [
						     ["" => DomainName],
						     ]],
	["sdb", "get-attributes gatt", GetAttributes, [
						       ["" => DomainName],
						       [i => ItemName],
						       [n => AttributeName],
						       [c => ConsistentRead],
						       ]],
	["sdb", "list-domains ldom", ListDomains, [
						   [max => MaxNumberOfDomains],
						   [next => NextToken],
						   ]],
	["sdb", "put-attributes patt", PutAttributes, [
						       ["" => DomainName],
						       [i => ItemName],
						       [n => "Attribute.N.Name"],
						       [v => "Attribute.N.Value"],
						       [replace => "Attribute.N.Replace"],
						       [xn => "Expected.N.Name"],
						       [xv => "Expected.N.Value"],
						       [exists => "Expected.N.Exists"],
						       ]],
	["sdb", "select", Select, [
				   ["" => SelectExpression],
				   [c => ConsistentRead],
				   [next => NextToken],
				   ]],
	);


$isUnix = guess_is_unix();
$home = get_home_directory();

# Figure out $cmd.  If the program is run as other than "aws", then $0 contains
# the command.  This way, you can link aws to the command names (with or without
# ec2 or s3 prefix) and not have to type "aws".
unshift @ARGV, $1 if $0 =~ /^(?:.*[\\\/])?(?:(?:ec2|s3|sqs|sdb)-?)?(.+?)(?:\..+)?$/ && $1 !~ /^l?aws/;


# parse meta-parameters, leaving parameters in @argv

{
    my(%keyword);

    # The %need_arg items must have a value.  If they aren't of the form
    # --foo=bar, then slurp up the next item as the value.  Thus, for example,
    #  --region=eu  and  --region eu  both work, with or without the =.
    my(%need_arg, $key_for_arg);
    @needs_arg{qw(region)} = undef;

    my(%meta);
    @meta{qw(1 cmd0 curl_options cut d delimiter dns_alias dump_xml exec expire_time fail h help http
	     insecure insecure_signing insecure_aws insecureaws install l limit_rate link
	     max_time marker md5 no_vhost prefix private progress public queue r region request requester retry
	     s3host sanity_check secrets_file set_acl sign silent simple t v verbose vv vvv wait xml)} = undef;

    my @awsrc = "";
    for (split(/(?:\#.*?(?=\n)|'(.*?)'|"((?:\\[\\\"]|.)*?)"|((?:\\.|\$.|[^\s\'\"\#])+))/s, load_file_silent("$home/.awsrc")))
    {
	if (/^\s+$/)
	{
	    push @awsrc, "" if length($awsrc[$#awsrc]);
	}
	else
	{
	    $awsrc[$#awsrc] .= $_;
	}
    }
    pop @awsrc unless length($awsrc[$#awsrc]);

    for (@awsrc, @ARGV)
    {
	if ($key_for_arg)
	{
	    $ {$key_for_arg} = $_;
	    undef $key_for_arg;
	}
	elsif (/^--([\w\-]+?)(?:=(.*))?$/s)
	{
	    my($key0, $val) = ($1, $2);
	    (my $key = $key0) =~ s/-/_/g;
	    if (exists $needs_arg{$key} && !defined $val)
	    {
		$key_for_arg = $key;
	    }
	    elsif (exists $keyword{$key})
	    {
		push @argv, $_;
	    }
	    else
	    {
		die "--$key0: mispelled meta parameter?\n" unless exists $meta{$key};
		$ {$key} = defined $val? $val: 1;
		# --cmd0 is used to call self but without getting the command from $0
		undef $cmd if $key eq "cmd0" && $val;
	    }
	}
	elsif (/^-(\w+)$/)
	{
	    if (exists $keyword{$1})
	    {
		push @argv, $_;
	    }
	    else
	    {
		for (split(//, $1))
		{
		    die "-$_: mispelled meta parameter?\n" unless exists $meta{$_};
		    s/^(\d)$/d$1/;
		    $ {$_}++;
		}
	    }
	}
	else
	{
	    if ($cmd)
	    {
		push @argv, $_;
	    }
	    else
	    {
		$cmd = $_;

		# moved this code here, so that arguments to specific ec2, s3, and sqs commands
		# are active only if the particular command is indicated

		# make a hash of aws keywords (%keyword), which are not treated as meta-parameters

		for (@cmd)
		{
		    next unless grep /^\Q$cmd\E$/, split(" ", $_->[1]);
		    $cmd_data = $_;
		    push @{$cmd_data->[3]}, ["filter", undef, undef, \&parse_filter] if $_->[1] =~ /\bdescribe/;
		    for (@{$cmd_data->[3]})
		    {
			for (split(" ", $_->[0]))
			{
			    (my $key = $_) =~ s/-/_/g;
			    $keyword{$key} = undef;
			}
		    }
		    last;
		}
	    }
	}
    }
}


$h ||= $help;
$v ||= $verbose;
$v = 2 if $vv;
$v = 3 if $vvv;

if ($cut)
{
    my $columns = $ENV{COLUMNS};
    ($columns) = qx[stty -a <&2] =~ /;\s*columns\s*(\d+);/s unless $columns;
    if ($columns)
    {
	$columns -= !!$ENV{EMACS};
	open STDOUT, "|cut -c -$columns";
    }
}

# Exercise for the reader: why is this END block here?  (Hint: bug in Perl?)
END {close STDOUT}


$s3host ||= $ENV{S3_URL} || "s3.amazonaws.com";


print STDERR "aws version: v$program_version  (ec2: $ec2_version, sqs: $sqs_version, elb: $elb_version, sdb: $sdb_version, iam: $iam_version)\n" if $v;

$insecsign = "--insecure" if $insecure || $insecure_signing;
$insecureaws = "--insecure" if $insecureaws || $insecure_aws;

$scheme = $http? "http": "https";

$silent ||= !-t;
$retry ||= 3;

$secrets_file ||= "$home/.s3cfg" if !-e "$home/.awssecret" && -e "$home/.s3cfg";
$secrets_file ||= "$home/.awssecret";

# unfortunately, you can't have a delimiter of "1" this way
if ($d || $delimiter == 1)
{
    $delimiter = "/";
}

for ([m => 60], [h => 60 * 60], [d => 24 * 60 * 60], [w => 7 * 24 * 60 * 60], [mo => 30 * 24 * 60 * 60], [y => 365.25 * 24 * 60 * 60])
{
    $expire_time = $1 * $_->[1] if $expire_time =~ /^(-?\d+)$_->[0]$/;
}


# run a sanity check if $home/.awsrc doesn't exists, or if it was requested

if (!-e "$home/.awsrc" || $sanity_check)
{
    if (!$silent)
    {
	if ($ENV{AWS_SECRET_ACCESS_KEY} && $ENV{AWS_ACCESS_KEY_ID})
	{
	}
	elsif (!-e $secrets_file)
	{
	    warn "sanity-check: \"$secrets_file\": file is missing.  (Format: AccessKeyID\\nSeecretAccessKey\\n)\n";
	}
	elsif (!-r $secrets_file)
	{
	    warn "sanity-check: \"$secrets_file\": file is not readable\n";
	}
	elsif ($isUnix)
	{
	    my $stat = (stat $secrets_file)[2] & 0777;
	    
	    if (($stat & 0477) != 0400)
	    {
		my @perm = (qw(x r w)) x 4;
		my $perm = join("", map {my $s = shift @perm; $_? $s: "-"} (split//, (unpack("B*", pack("n", $stat))))[6 .. 15]);
		warn "sanity-check: \"$secrets_file\": file permissions are $perm.  Should be -rw-------\n";
	    }
	}
    }

    my($curl_version) = qx[curl -V] =~ /^curl\s+([\d\.]+)/s;
    print "curl version: $curl_version\n" if $v >= 2;
    if (xcmp($curl_version, "7.12.3") < 0)
    {
	$retry = undef;
	warn "sanity-check: This curl (v$curl_version) does not support --retry (>= v7.12.3), so --retry is disabled\n" unless $silent;
    }

    my $aws = qx[curl -q -s $insecureaws --dump-header - $scheme://connection.$s3host/test];
    print $aws if $v >= 2;
    my($d, $mon, $y, $h, $m, $s) = $aws =~ /^Date: ..., (..) (...) (....) (..):(..):(..) GMT\r?$/m;

    if (!$d)
    {
	$aws = qx[curl -q -s --insecure --dump-header - $scheme://connection.$s3host/test];
	($d, $mon, $y, $h, $m, $s) = $aws =~ /^Date: ..., (..) (...) (....) (..):(..):(..) GMT\r?$/m;
	if ($d)
	{
	    warn "sanity-check: Your host SSL certificates are not working for curl.exe.  Try using --insecure-aws (e.g., aws --insecure-aws ls)\n";
	}
	else
	{
	    $aws = qx[curl -q -s --insecure --dump-header - http://connection.$s3host/test];
	    ($d, $mon, $y, $h, $m, $s) = $aws =~ /^Date: ..., (..) (...) (....) (..):(..):(..) GMT\r?$/m;
	    if ($d)
	    {
		die "sanity-check:  Your curl doesn't seem to support SSL.  Try using --http (e.g., aws --http ls)\n";
	    }
	    else
	    {
		die "sanity-check:  Problems accessing AWS.  Is curl installed?\n";
	    }
	}
    }

    if (eval {require Time::Local})
    {
	$mon = {Jan => 0, Feb => 1, Mar => 2, Apr => 3, May => 4, Jun => 5, Jul => 6, Aug => 7, Sep => 8, Oct => 9, Nov => 10, Dec => 11}->{$mon};
	my $t = Time::Local::timegm($s, $m, $h, $d, $mon, $y);
	$time_offset = $t - time;
	warn "sanity-check: Your system clock is @{[abs($time_offset)]} seconds @{[$time_offset > 0? 'behind': 'ahead']}.\n" if !$silent && abs($time_offset) > 5;
    }
}

$curl_options .= " -q -g -S";
$curl_options .= " --remote-time";
$curl_options .= " --retry $retry" if $retry;
$curl_options .= " --fail" if $fail;
$curl_options .= " --verbose" if $v >= 2;
$curl_options .= $progress? " --progress": " -s";
$curl_options .= " --max-time $max_time" if $max_time;
$curl_options .= " --limit-rate $limit_rate" if $limit_rate;


#use Digest::SHA1 qw(sha1);
#use Digest::SHA::PurePerl qw(sha1);
#use MIME::Base64; -- added encode_base64() below

use IO::File;
use File::Temp qw(tempfile);
use Digest::MD5 qw(md5 md5_hex);


if ($sign)
{
    sysread STDIN, my $data, $ENV{CONTENT_LENGTH};
    $data ||= $sign;

    if ($v >= 2)
    {
	(my $pretty = $data) =~ s/\n/\\n/sg;
	print STDERR "data = $pretty\n";
    }

    my($sig, $awskey) = sign($data);

    $data = "$sig\n$awskey\n\n";

    if (exists $ENV{QUERY_STRING})
    {
	print "Content-Length: @{[length($data)]}\nContent-Type: text/plain\n\n";
    }

    print $data;

    exit;
}


if ($install)
{
    die "Usage: .../aws --install\n" if $install && @argv;
    
    if (-w "/usr/bin")
    {
	chomp(my $dir = qx[pwd]);
	my $path = $0;
	$path = "$dir/$0" if $0 !~ /^\//;

	if ($dir !~ /^\/usr\/bin$/)
	{
	    print STDERR "copying aws to /usr/bin/\n";
	    my $aws = load_file($0) or die "installation failed (can't load script)\n";
	    if (-e "/usr/bin/aws")
	    {
		unlink "/usr/bin/aws" or die "can't unlink old /usr/bin/aws\n";
	    }
	    save_file("/usr/bin/aws", $aws);
	    die "installation failed (can't copy script)\n" unless load_file("/usr/bin/aws") eq $aws;
	    chmod 0555, "/usr/bin/aws";
	    chdir "/usr/bin";
	}
    }

    chmod 0555, $0;
    make_links($0);
    die "installation failed\n";
}


if ($link)
{
    die "Usage: .../aws --link[=short|long] [-bare]\n" if $link && @argv;

    make_links($0);
}

sub make_links
{
    my($target) = @_;

    #
    # Create symlinks to this program named for all available
    # commands.  Then the script can be invoked as "s3mkdir foo"
    # rather than "aws mkdir foo".  (Run this command in /usr/bin
    # or /usr/local/bin.)
    #
    # aws -link
    #	symlinks all command names (ec2-delete-group, ec2delgrp, ec2-describe-groups, ec2dgrp, etc.)
    # aws -link=short
    #	symlinks only the short versions of command names (ec2delgrp, ec2dgrp, etc.)
    # aws -link=long
    #	symlinks only the long versions of command names (ec2-delete-group, ec2-describe-groups, etc.)
    #
    # The -bare option creates symlinks without the ec2 and s3 prefixes
    # (delete-group, delgrp, etc.).  Be careful using this option, as
    # commands named "ls", "mkdir", "rmdir", etc. are created.

    for (@cmd)
    {
	my($service, $cmd, $action) = @$_;

	for my $fn (split(' ', $cmd))
	{
	    my($dash) = $fn =~ /(-)/;

	    next if $dash && $link eq "short";
	    next if !$dash && $link eq "long";

	    $fn = "$service$dash$fn" unless $bare;

	    unlink $fn;
	    symlink($target, $fn) or die "$fn: $!\n";
	    #print "symlink $fn --> $target\n";
	}
    }

    exit;
}


if (!$cmd_data)
{
    my $output = "$cmd: unknown command\n" if $cmd;
    $output .= "Usage: aws ACTION [--help]\n\twhere ACTION is one of\n";
    my(%output);
    for (@cmd)
    {
	my($service, $cmd, $action, $param) = @$_;
	$output{$service} .= " $cmd";
    }
    for my $service (sort keys %output)
    {
	$output .= "\t$service";
	while ($output{$service} =~ /\s*(.{1,80})(?:\s|$)/g)
	{
	    my($one) = ($1);
	    $output .= "\t" if $output =~ /\n$/;
	    $output .= "\t\t$one\n";
	}
    }
    $output .= "aws version: v$program_version  (ec2 $ec2_version, sqs $sqs_version, elb $elb_version, sdb $sdb_version)\n";
    die $output;
}


{
    my($service, $cmd, $action, $param) = @$cmd_data;

    if ($h)
    {
	my $help = "Usage: aws $cmd";
	for (@$param)
	{
	    my($aa, $key, $default) = @$_;

	    my(@help);
	    my @aa = split(/\s+/, $aa);
	    @aa = "" unless @aa;
	    for my $a (@aa)
	    {
		my $x = "-$a " if $a;
		$x = "--$a " if length($a) > 1;

		my($name, $N) = $key =~ /^(.*?)(N?)$/;
		my $ddd = "..." if $N eq "N";
		if ($key =~ /\.N\./)
		{
		    ($name) = $key =~ /.*\.(.*)$/;
		    $ddd = "...";
		}
		my $def = " ($default)" if $default;

		push @help, "$x$name$ddd$def";
	    }
	    $help .= " [" . join("|", @help) . "]";
	}
	$help .= " BUCKET[/OBJECT] [SOURCE]" if $service eq "s3";
	$help .= "\n";
	print STDERR $help;
	exit;
    }


    my($result);

    if ($service eq "ec2" || $service eq "sqs" || $service eq "elb" || $service eq "sdb" || $service eq "iam")
    {
	#print STDERR "(@{[join(', ', @argv)]})\n" if $v;

	my(%count);

	my @list = (Action => $action);

	for (my $i = 0; $i < @argv; $i++)
	{
	    my($b);

	    if ($argv[$i] =~ /^--?(.*)$/)
	    {
		($b) = ($1);
		++$i;
	    }

	    # The Amazon tools have special cases in them too
	    $list[1] = "GetGroupPolicy" if $action eq ListGroupPolicies && $b eq "p";
	    $list[1] = "GetUserPolicy" if $action eq ListUserPolicies && $b eq "p";

	    #
	    # find the right param
	    #
	    for (@$param)
	    {
		my($a, $key, $default, $cref) = @$_;
		# A leading space in $a is significant, so careful with split()...
		next unless length($a) == 0 && length($b) == 0 || grep /^$b$/, split(/\s+/, $a);
		my $data = $argv[$i];
		my $count = ++$count{$a};
		if ($key)
		{
		    $key =~ s/N$/\.$count/;
		    $key =~ s/\.N\./\.$count\./;
		    $data = $cref->($data) if $cref;
		    push @list, $key => $data;
		}
		else
		{
		    $data = $cref->($data);
		    for (my $i = 0; $i < @$data; $i += 2)
		    {
			my $key = $data->[$i];
			$key =~ s/N$/\.$count/;
			$key =~ s/\.N\./\.$count\./;
			push @list, $key => $data->[$i + 1];
		    }
		}
		last;
	    }
	}

	for (@$param)
	{
	    my($a, $key, $default, $cref) = @$_;
	    if ($default && $count{$a} == 0)
	    {
		my $count = ++$count{$a};
		if ($key)
		{
		    $key =~ s/N$/\.$count/;
		    $key =~ s/\.N\./\.$count\./;
		    $default = $cref->($data) if $cref;
		    push @list, $key => $default;
		}
		else
		{
		    my $data = $cref->($default);
		    for (my $i = 0; $i < @$data; $i += 2)
		    {
			my $key = $data->[$i];
			$key =~ s/N$/\.$count/;
			$key =~ s/\.N\./\.$count\./;
			push @list, $key => $data->[$i + 1];
		    }
		}
	    }
	}

	push @list, @final_list;
	print STDERR "ec2(@{[join(', ', @list)]})\n" if $v;

	$result = ec2($service, @list);
    }
    elsif ($service eq "s3")
    {
	my($last_marker, $marker);

	for (;;)
	{
	    my $r = s3($action, $marker, (grep(!/^(?:x-amz-|Cache-|Content-|Expires:|If-|Range:)/i, @argv))[0, 1], grep(/^(?:x-amz-|Cache-|Content-|Expires:|If-|Range:)/i, @argv));
	    if ($r !~ /^<\?xml/)
	    {
		print $r;
		exit;
	    }
	    $r =~ s/<\?xml.*?>\r?\s*//;
	    $result .= $r;
	    ($marker) = $r =~ /.*<Key>(.*?)<\/Key>/;
	    last if $r !~ /<IsTruncated>true<\/IsTruncated>/ || $marker le $last_marker;
	    $last_marker = $marker;
	}
    }
    else
    {
	die;
    }

    if ($xml)
    {
	print xmlpp($result);
    }
    elsif ($result =~ /<ListBucketResult|<ListAllMyBucketsResult/ && ($l || $d1 || $exec || $simple))
    {
	#	<ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
        #	<Owner>
	#		<ID>c1438ce900acb0db547b3708dc29ca60370d8174ee55305050d2990dcf27109c</ID>
	#		<DisplayName>timkay681</DisplayName>
        #	</Owner>
        #	<Buckets>
	#		<Bucket>
	#			<Name>3.14</Name>
	#			<CreationDate>2007-03-04T22:29:34.000Z</CreationDate>
	#		</Bucket>
	#

	#	<ListBucketResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
	#		<Name>boopsielog</Name>
	#		<Prefix></Prefix>
	#		<Marker></Marker>
	#		<MaxKeys>1000</MaxKeys>
	#		<IsTruncated>false</IsTruncated>
	#		<Contents>
	#		        <Key>ec201-2008-08-20-access.log.gz</Key>
	#		        <LastModified>2008-08-21T03:01:51.000Z</LastModified>
	#		        <ETag>&quot;baa27b2e8def9acf8c2f3690e230e37a&quot;</ETag>
	#		        <Size>2405563</Size>
	#		        <Owner>
	#		                <ID>c1438ce900acb0db547b3708dc29ca60370d8174ee55305050d2990dcf27109c</ID>
	#		                <DisplayName>timkay681</DisplayName>
	#		        </Owner>
	#		        <StorageClass>STANDARD</StorageClass>
	#		</Contents>

	my $isdir = $result =~ /<ListAllMyBucketsResult/;
	my($owner1) = $result =~ /<DisplayName>(.*?)<\/DisplayName>/s;

	my(@result);

	while ($result =~ /<(?:Contents|Bucket)>\s*(.*?)\s*<\/(?:Contents|Bucket)>/sg)
	{
	    my($item) = ($1);
	    my $key = dentity($item =~ /<(?:Key|Name)>(.*?)<\/(?:Key|Name)>/s);
	    my($size) = $item =~ /<Size>(.*?)<\/Size>/s;
	    my($mod) = $item =~ /<(?:LastModified|CreationDate)>(.*?)<\/(?:LastModified|CreationDate)>/s;
	    my($owner) = $item =~ /<DisplayName>(.*?)<\/DisplayName>/s;

	    for ($mod)
	    {
		s/T/ /g;
		s/\.000Z//;
	    }

	    push @result, [$item, $key, $size, $mod, $owner || $owner1 || "unknown"];
	}

	if ($t)
	{
	    @result = sort {$a->[3] cmp $b->[3]} @result;
	}

	if ($r)
	{
	    @result = reverse @result;
	}

	for (@result)
	{
	    my($item, $key, $size, $mod, $owner) = (@$_);
	    if ($l)
	    {
		$key = printable($key);
		if ($isdir)
		{
		    print "drwx------  2 $owner   0 $mod $key\n";
		}
		else
		{
		    printf "-rw-------  1 $owner %10.0f $mod %s\n", $size, $key;
		}
	    }
	    elsif ($d1)
	    {
		print "$key\n";
	    }
	    elsif ($simple)
	    {
		printf "%10.0f\t$mod\t%s\n", $size, $key;
	    }
	    elsif ($exec)
	    {
		#local $_ = sprintf "%10.0f\t$mod\t$key\n", $size;
		#local @_ = ($size, $mod, $key);
		my($bucket, $prefix) = split(/\//, $argv[0], 2);
		eval $exec;
		last if $? & 127; # if the user hits control-c during a system() call...
	    }
	}
    }
    elsif ($result =~ /<CreateKeyPairResponse/)
    {
	print $result =~ /<keyMaterial>(.*?)<\/keyMaterial>/s, "\n";
    }
    elsif ($result =~ /<GetConsoleOutputResponse/)
    {
	print decode_base64($result =~ /<output>(.*?)<\/output>/s);
    }
    elsif ($result =~ /<RunInstancesResponse|<DescribeInstancesResponse/ && ($simple || $wait))
    {
	for (;;)
	{
	    my(@instanceId, @instanceState, @dnsName, @groupId);

	    while ($result =~ /(<item(?:<item(?:<item.*?<\/item>|.)*?<\/item>|.)*?<\/item>)/sg)
	    {
		my($result) = ($1);
		my($groupId) = $result =~ /<groupId>(.*?)<\/groupId>/;
		while ($result =~ /(<instancesSet.*?<\/instancesSet>)/sg)
		{
		    my($result) = ($1);
		    while ($result =~ /(<item(?:<item.*?<\/item>|.)*?<\/item>)/sg)
		    {
			my($result) = ($1);
			my($instanceId) = $result =~ /<instanceId>(.*?)<\/instanceId>/s;
			my($instanceState) = map {/<name>(.*?)<\/name>/s} $result =~ /<instanceState>(.*?)<\/instanceState>/s;
			my($dnsName) = $result =~ /<dnsName>(.*?)<\/dnsName>/s;
			push @instanceId, $instanceId;
			push @instanceState, $instanceState;
			push @dnsName, $dnsName;
			push @groupId, $groupId;
		    }
		}
	    }

	    my($pending);

	    for (my $i = 0; $i < @instanceId; $i++)
	    {
		$pending += $instanceState[$i] eq "pending";
		print "$instanceId[$i]\t$instanceState[$i]\t$dnsName[$i]\t$groupId[$i]\n";
	    }

	    last unless $wait && $pending;

	    sleep $wait;
	    $result = qx[$0 --cmd0 --xml --region=$region describe-instances @instanceId];
	}
    }
    elsif ($result =~ /<ListQueuesResult/)
    {
	if ($simple)
	{
	    while ($result =~ /<QueueUrl>(.*?)<\/QueueUrl>/g)
	    {
		my($q) = ($1);
		$q =~ s/^https?:\/\/.*?(?=\/)//;
		print "$q\n";
	    }
	}
	else
	{
	    print ary2tab(xml2ary(ListQueuesResult, $result), {title => "Queue URLs", empty => "no queues\n"});
	}
    }
    elsif ($result =~ /<GetQueueAttributesResponse/ && $simple)
    {
	while ($result =~ /<Attribute>(.*?)<\/Attribute>/sg)
	{
	    if ($1 =~ /<Name>(.*?)<\/Name>.*?<Value>(.*?)<\/Value>/s)
	    {
		print "$1\t$2\n";
	    }
	}
    }
####
    elsif ($result =~ /<ListDomainsResponse/)
    {
	my $ary = xml2ary(ListDomainsResult, $result);
	if ($d1)
	{
	    for (@$ary)
	    {
		print $_->[1], "\n";
	    }
	}
	else
	{
	    print ary2tab([@$ary]);
	}
    }
    elsif ($result =~ /<GetAttributesResponse/ && $d1)
    {
	while ($result =~ /<Attribute>(.*?)<\/Attribute>/sg)
	{
	    my($name, $value) = $1 =~ /<Name>(.*?)<\/Name>\s*<Value>(.*?)<\/Value>/s;
	    print "$name\t$value\n";
	}
    }
    elsif ($result =~ /<SelectResponse/ && ($simple || $d1))
    {
	while ($result =~ /<Item>(.*?)<\/Item>/sg)
	{
	    my($item, $attr) = $1 =~ /<Name>(.*?)<\/Name>(.*)/;
	    while ($attr =~ /<Name>(.*?)<\/Name>\s*<Value>(.*?)<\/Value>/sg)
	    {
		print "$item\t$1\t$2\n";
	    }
	}
    }
    elsif ($result =~ /<ReceiveMessageResult/)
    {
	if ($exec)
	{
	    print xmlpp($result) if $v;
	    my($handle) = $result =~ /<ReceiptHandle>(.*?)<\/ReceiptHandle>/;
	    my $body = decode_url($result =~ /<Body>(.*?)<\/Body>/);
	    if ($handle && $body)
	    {
		$exec = 'system "$body"' if $exec == 1;
		my $rc = eval $exec;
		if ($rc)
		{
		    print "exec evaluated to non-zero ($rc): message not deleted from queue\n";
		}
		else
		{
		    my $cmd = qq[$0 dm $argv[0] --handle $handle];
		    print "$cmd\n" if $v;
		    my $dm = qx[$cmd];
		    print "$dm\n" if $v;
		}
	    }
	}
	else
	{
	    my $ary = xml2ary(Message, $result);
	    if ($simple)
	    {
		my($id, $handle, $md5, $body);
		for (@$ary)
		{
		    $id = $_->[1] if $_->[0] eq MessageId;
		    $handle = $_->[1] if $_->[0] eq ReceiptHandle;
		    $md5 = $_->[1] if $_->[0] eq MD5OfBody;
		    $body = decode_url($_->[1]) if $_->[0] eq Body;
		}
		print "$handle\t$body\t$id\t$md5\n" if $handle;
	    }
	    else
	    {
		print ary2tab($ary, {title => "Messages", empty => "no messages\n"});
	    }
	}
    }
    elsif ($result =~ /<SendMessageResponse/ && $simple)
    {
	my($md5) = $result =~ /<MD5OfMessageBody>(.*?)<\/MD5OfMessageBody>/;
	my($id) = $result =~ /<MessageId>(.*?)<\/MessageId>/;
	print "$md5\t$id\n";
    }
    elsif ($result =~ /<(?:GetGroupPolicyResponse|GetUserPolicyResponse)/)
    {
	my($doc) = $result =~ /<PolicyDocument>(.*?)<\/PolicyDocument>/s;
	$doc =~ s/%(..)/pack(H2,$1)/ge;
	print $doc;
    }
    elsif ($result =~ /<(?:ListUserPoliciesResponse)/)
    {
	my @member = $result =~ /<member>(.*?)<\/member>/g;
	print join("\n", @member, undef);
    }
    elsif ($result =~ /<GetQueueAttributesResponse/)
    {
	print ary2tab(xml2ary(GetQueueAttributesResult, $result, {key => Name, value => Value}), {title => "Attributes", empty => "no attributes\n"});
    }
    elsif ($result =~ /<DescribeTagsResponse/ && $simple)
    {
	while ($result =~ /<item>(.*?)<\/item>/sg)
	{
	    my($item) = ($1);
	    my(@item);
	    while ($item =~ /<(.*?)>(.*?)<\/\1>/g)
	    {
		push @item, $2;
	    }
	    print join("\t", @item), "\n";
	}
    }
    elsif ($result =~ /<ListGroupsResponse|GetGroupResponse|ListUsersResponse|ListAccessKeysResponse/ && $simple)
    {
	print map {join("\t", @$_) . "\n"} @{xml2Dary("member", $result)};
    }
    elsif ($result =~ /<ListGroupPoliciesResponse/ && $simple)
    {
	print map {join("\t", @$_) . "\n"} @{xml2Dary("PolicyNames", $result)};
    }
    else
    {
	print xml2tab($result) || xmlpp($result);
    }

    exit $exit_code;
}


sub xml2Dary
{
    my($tag, $result, $param, @result) = @_;
    my(@key);
    while ($result =~ /<$tag.*?>(.*?)<\/$tag>/sg)
    {
	my($elt) = ($1);
	my(@val);
	while ($elt =~ /<(.*?)>(.*?)<\/\1>/sg)
	{
	    my($key, $val) = ($1, $2);
	    push @key, $key if !@result;
	    push @val, $val;
	}
	push @result, \@key if !@result && $param->{head};
	push @result, \@val;
    }
    \@result;
}

sub xml2ary
{
    my($tag, $result, $param, @result) = @_;
    for ($result =~ /<$tag.*?>(.*?)<\/$tag>/sg)
    {
	while (/<(.*?)>(.*?)<\/\1>/sg)
	{
	    my($key, $val1) = ($1, $2);
	    my($val);
	    while ($val1 =~ /<(.+?)>(.*?)<\/\1>/sg)
	    {
		if ($1 eq $param->{key})
		{
		    $key = $2;
		}
		elsif ($1 eq $param->{value})
		{
		    $val = $2;
		}
		else
		{
		    $val .= " " if $val;
		    $val .= "$1=$2";
		}
	    }
	    $val = $val1 unless length($val);
	    push @result, [$key, $val];
	}
    }
    \@result;
}


sub ary2tab
{
    my($ary, $param) = @_;
    return $param->{empty} if exists $param->{empty} && !@$ary;
    my(@width);
    for (@$ary)
    {
	if (ref $_ eq SCALAR)
	{
	    $_ = [$_];
	}

	if (ref $_ eq ARRAY)
	{
	    for (my $i = 0; $i < @$_; $i++)
	    {
		$width[$i] = length($_->[$i]) if $width[$i] < length($_->[$i]);
	    }
	}
    }
    if ($param->{title})
    {
	my $width = -1;
	$width += 2 + $_ for @width;
	my $l = int(($width - length($param->{title})) / 2);
	my $r = $width - length($param->{title}) - $l;
	$output .= "+" . "-" x (@width - 1);
	$output .= "-" x (2 + $_) for @width;
	$output .= "+\n";
	$output .= "| " . " " x $l . $param->{title} . " " x $r  . " |\n";
    }
    $output .= "+" . "-" x (2 + $_) for @width;
    $output .= "+\n";
    for (@$ary)
    {
	for (my $i = 0; $i < @width; $i++)
	{
	    $output .= "| " . $_->[$i] . " " x (1 + $width[$i] - length($_->[$i]));
	}
	$output .= "|\n";
    }
    $output .= "+" . "-" x (2 + $_) for @width;
    $output .= "+\n";
}


sub xml2tab
{
    my($xml) = @_;
    my($output);
    $xml =~ s/^<\?xml.*?>(\r?\n)*//;
    my @xml = grep !/^\s*$/, split(/(<.*?>)/, $xml);
    my(@tag, @depth);
    my $depth = 0;
    for (my $i = 0; $i < @xml; $i++)
    {
	if ($xml[$i] =~ /^<(\w+)\/>$/)
	{
	    next;
	}
	elsif ($xml[$i] =~ /^<(\w+)/)
	{
	    my($tag) = ($1);
	    $tag[$i] = $tag;
	    $depth[$i] = ++$depth;
	}
	elsif ($xml[$i] =~ /^<\/(\w+)/)
	{
	    my($tag) = ($1);
	    for (my $j = $i - 1; $j >= 0; $j--)
	    {
		next if $depth[$j] > $depth;
		next if $tag[$j] ne $tag;
		$depth = $depth[$j] - 1;
		last;
	    }
	}
	else
	{
	    $tag[$i] = $xml[$i];
	    $depth[$i] = 99;
	}
    }

    my(@parent, $depth, %head, @head, @table, $col);

    my $skipre = qr/^(?:amiLaunchIndex|ETag|HostId|ipPermissions|Owner)$/;

    for (my $i = 0; $i <= @xml; $i++)
    {
	$parent[$depth[$i]] = $tag[$i];

	if (@head && $i == @xml || $depth[$i] && $depth[$i] < $depth)
	{
	    unless (@head == 1 && $head[0] eq "RequestId")
	    {
		for (@table)
		{
		    $_ = [map {printable(dentity($_))} @$_{@head}];
		}

		unshift @table, [@head];

		my(@width);

		for (@table)
		{
		    for (my $i = 0; $i < @head; $i++)
		    {
			if ($head[$i] =~ /^(?:privateDnsName|dnsName)$/)
			{
			    chomp(my $me = qx[me $_->[$i]]);
			    $_->[$i] = $me if $me;
			}
			my $length = length($_->[$i]);
			$width[$i] = $length if $width[$i] < $length;
		    }
		}

		my $sep = "+";

		for (my $i = 0; $i < @head; $i++)
		{
		    next if $head[$i] =~ /$skipre/;
		    $sep .= "-" x (2 + $width[$i]) . "+";
		}

		for (my $j = 0; $j < @table; $j++)
		{
		    $output .= "$sep\n" if $j < 2;

		    for (my $i = 0; $i < @head; $i++)
		    {
			next if $head[$i] =~ /$skipre/;
			my $len = length($table[$j]->[$i]);
			my $pad = $width[$i] - $len;
			my $l = 1 + int($pad / 2);	# center justify
			$l = 1 if $j;			# left justify all but first row
			my $r = 2 + $pad - $l;
			$output .= "|" . " " x $l . $table[$j]->[$i] . " " x $r;
		    }
		    $output .= "|\n";
		}

		$output .= "$sep\n";
	    }

	    $depth = 0;
	    %head = ();
	    @head = ();
	    @table = ();
	}

	my $tag2 = "$parent[$depth[$i] - 1]-$tag[$i]";

	if ($tag[$i] =~ /^(?:LocationConstraint|Grant
			   |AttachVolumeResponse|Bucket|Contents|AuthorizeSecurityGroupIngressResponse|CopyObjectResult
			   |CreateKeyPairResponse|CreateSecurityGroupResponse|CreateImageResponse|CreateSnapshotResponse|CreateVolumeResponse
			   |DeleteSecurityGroupResponse|DeleteKeyPairResponse|DeleteSnapshotResponse|DeleteVolumeResponse
			   |DetachVolumeResponse|Error|GetConsoleOutputResponse|ListBucketResult|RebootInstancesResponse
			   |RevokeSecurityGroupIngressResponse|AllocateAddressResponse|ReleaseAddressResponse|AssociateAddressResponse|DescribeRegionsResponse
			   |CreateQueueResponse|ResponseMetadata|DescribeSnapshotAttributeResponse|ModifySnapshotAttributeResponse|ResetSnapshotAttributeResponse
			   |CreateLoadBalancerResponse|DeleteLoadBalancerResponse
			   |DescribeSpotInstanceRequestsResponse|CancelSpotInstanceRequestsResponse|RequestSpotInstancesResponse|DescribeSpotPriceHistoryResponse
			   |ListGroupPoliciesResult|GetGroupPolicyResult
			   |SendMessageResult|CreateTagsResponse|DeleteTagsResponse
			   )$/x
	    || $tag2 =~ /^(?:addressesSet-item|availabilityZoneInfo-item|imagesSet-item|instancesSet-item
			   |ipPermissions-item|keySet-item|reservedInstancesOfferingsSet-item|securityGroupInfo-item|volumeSet-item|snapshotSet-item|regionInfo-item
			   |ReceiveMessageResult-Message
			   |LoadBalancerDescriptions-member
			   |ReceiveMessageResult-Message|spotInstanceRequestSet-item|spotPriceHistorySet-item
			   |GetAttributesResult-Attribute|SelectResult-Item
			   |CreateGroupResult-Group|Groups-member|CreateUserResult-User|Users-member|GetUserResult-User
			   |CreateAccessKeyResult-AccessKey|AccessKeyMetadata-member|tagSet-item
			   )$/x
	    || $i == @xml)
	{
	    $depth = $depth[$i];
	    ###push @table, {"" => $tag[$i]};
	    push @table, {};
	}

	next unless $depth;

	if ($depth[$i] == $depth + 1)
	{
	    $col = $tag[$i];
	    push @head, $col unless exists $head{$col};
	    $head{$col} = undef;
	}
	if ($depth[$i] >= $depth + 2)
	{
	    $table[$#table]->{$col} .= " " if $table[$#table]->{$col} && $depth[$i] < 99;
	    $table[$#table]->{$col} .= $tag[$i];
	    $table[$#table]->{$col} .= "=" if $depth[$i] < 99;
	}
    }

    if (!@table || $dump_xml)
    {
	print STDERR "$xml\n";

	for (my $i = 0; $i < @xml; $i++)
	{
	    next unless $tag[$i];
	    print STDERR $depth[$i], "  " x $depth[$i], "$tag[$i]\n";
	}
    }

    $output;
}

sub xmlpp
{
    my($xml) = @_;
    my($indent, @path, $defer, @defer, $result) = "\t";

    for ($xml =~ /<.*?>|[^<]*/sg)
    {
	if (/^<\/(\w+)/ || /^<(!\[endif)/)		# </... or <!--[endif]
	{
	    my($tag) = ($1);
	    $tag = $path[$#path] if $tag eq "![endif";
	    push @path, @defer;
	    while (@path)
	    {
		my $pop = pop @path;
		last if $pop eq $tag;
	    }
            $result .= "@{[$indent x @path]}@{[$defer =~ /^\s*(.*?)\s*$/s]}$_\n" if $defer || $_;
            $defer = "";
	    @defer = ();
 	}

	elsif (/[\/\?]\s*\>$/)				# .../> or ...?>
	{
            $result .= "@{[$indent x @path]}@{[$defer =~ /^\s*(.*?)\s*$/s]}\n" if $defer;
	    push @path, @defer;
            $result .= "@{[$indent x @path]}@{[/^\s*(.*?)\s*$/s]}\n" if $_;
            $defer = "";
	    @defer = ();
	}

	elsif (/^(?:[^<]|<!(?:[^-]|--[^\[]))/)		# (not <) or (< then not -) or (<!-- then not [)
	{
	    if (!/^\s*$/)
	    {
		if ($defer)
		{
		    $defer .= $_;
		}
		else
		{
		    $result .= "@{[$indent x @path]}@{[/^\s*(.*?)\s*$/s]}\n";
		}
	    }
	}

	else						# <...
	{
	    $result .= "@{[$indent x @path]}@{[$defer =~ /^\s*(.*?)\s*$/s]}\n" if $defer;
	    push @path, @defer;
	    $defer = $_;
	    @defer = /^<([^<>\s]+)/;
	}
    }

    $result .= "@{[$indent x @path]}@{[$defer =~ /^\s*(.*?)\s*$/s]}\n" if $defer;

    $result;
}


sub s3
{
    my($verb, $marker, $name, $file, @header) = @_;

    $file ||= $name if $verb eq PUT && $ENV{S3_DIR};
    $name = "$ENV{S3_DIR}/$name" if $ENV{S3_DIR};
    $name =~ s/^([^\?\/]+)(\?|$ )/$1\/$2/xs;
    $name .= $file if $verb eq PUT && $name =~ /\/$/;

    # add a Content-Type header using mime.types
    if ($verb eq PUT)
    {
	my($found_content_type, $found_content_md5);
	for (@header)
	{
	    $found_content_type++ if /^content-type:/i;
	    $found_content_md5++ if /^content-md5:/i;
	}
	if (!$found_content_type)
	{
	    my($ext) = $name =~ /\.(\w+)$/;
	    if ($ext)
	    {
		local(@ARGV);
		for (qw(mime.types /etc/mime.types))
		{
		    push @ARGV, $_ if -e $_;
		}
		if (@ARGV)
		{
		    while (<>)
		    {
			my($type, @ext) = split(/\s+/);
			if (grep /^$ext$/, @ext)
			{
			    push @header, "Content-Type: $type";
			    print STDERR "setting $header[$#header]\n" if $v;
			    last;
			}
		    }
		}
	    }
	}
	if (!$found_content_md5 && $md5)
	{
	    # Too memory intensive:
	    #my $md5 = encode_base64(md5(load_file($file)), "");

	    # Uses Digest::MD5::File that isn't in base perl:
	    # (Use this choice for Windows, after installing the package)
	    #use Digest::MD5::File qw(file_md5);
	    #my $md5 = encode_base64(file_md5($file), "");

	    # Just right:
	    my $md5 = encode_base64(pack("H*", (split(" ", qx[md5sum @{[cq($file)]}]))[0]), "");

	    push @header, "Content-MD5: $md5";
	    print STDERR "setting $header[$#header]\n" if $v;
	}
    }

    $set_acl = "public-read"	if $public;
    $set_acl = "private"	if $private;
    push @header, "x-amz-acl: $set_acl" if $verb eq PUT && $set_acl;

    $requester = "requester" if $requester == 1;
    push @header, "x-amz-request-payer: $requester" if $requester;

    # read from stdin when
    #	aws put target
    #	aws put target -
    # but not
    #	aws put target?acl
    # what about
    #	aws put target?location

    my($temp_fh);

    if ($verb eq PUT && ($file eq "-" || $file eq "" && $name !~ /\?acl$/))
    {
	# and not when a terminal
	die "$0: will not to read from terminal (use \"-\" for filename to force)\n" if -t && $file ne "-";

	($temp_fh, $file) = tempfile(UNLINK => 1);
	while (STDIN->read(my $buf, 16_384))
	{
	    print $temp_fh $buf;
	}
	$temp_fh->flush;
    }

    # added a case for "copy", so that the source moves to a header
    if ($verb eq COPY)
    {
	if ($name =~ /\/$/)
	{
	    my($what) = $file =~ /([^\/]+)$/;
	    $name .= $what;
	}
	if ($file !~ /^\//)
	{
	    (my $where = $name) =~ s/\/[^\/]+$/\//;
	    $file = "/$where$file";
	}
	push @header, "x-amz-copy-source: @{[encode_url($file)]}";
	undef $file;
	$verb = PUT;
    }

    my($prefix);

    # added a case for "ls", so that a prefix can be specified
    # (otherwise, the prefix looks like an object name)
    if ($verb eq LS)
    {
	$name =~ s/^\///;
	($name, $prefix) = split(/\//, $name, 2);
	$name .= "/" if $name;
	$prefix ||= $file;
	undef $file;
	$verb = GET;
    }

    my($ub, $uo, $uq) = $name =~ /^(.+?)(?:\/(.*?))?(\?(?:acl|location|logging|bittorrent|requestPayment|versioning|versions))?$/s;
    my $uname = encode_url($ub) . "/" . encode_url($uo) . $uq if $name;

    if ($v >= 2)
    {
	print "name = $name\n";
	print "ub = $ub\n";
	print "uo = $uo\n";
	print "uq = $uq\n";
	print "uname = $uname\n";
    }

    my($vhost, $vname) = ($s3host, $uname);
    if (!$no_vhost)
    {
	($vhost, $vname) = ($dns_alias? $1: "$1.$vhost", $2) if $uname =~ /^([0-9a-z][\.\-0-9a-z]{1,61}[0-9a-z])(?:\/(.*))?$/;
    }
    print STDERR "vhost=$vhost  vname=$vname\n" if $v;

    my $isGETobj = ($verb eq HEAD || $verb eq GET) && $uname =~ /\/./ && $uname !~ /\?/;
    my $expires = time + ($expire_time || 30) + $time_offset;

    my($content_type, $content_md5);

    for (@header)
    {
	if (/^(.*?):\s*(.*)$/)
	{
	    $content_type = $2 if lc $1 eq "content-type";
	    $content_md5 = $2 if lc $1 eq "content-md5";
	}
    }

    my $header_sign = join("\n", sort(map {s/^(.*?):\s*/\L$1:/s; $_} grep /^x-amz-/, @header), "") if @header;
    my $header = join(" --header ", undef, map {cq($_)} @header);

    if ($isGETobj && !$fail && !$request)
    {
	my $data = "HEAD\n$content_md5\n$content_type\n$expires\n$header_sign/$uname";
	my($sig, $awskey) = sign($data);
	my $url = "$scheme://$vhost/$vname@{[$vname =~ /\?/? '&': '?']}AWSAccessKeyId=@{[encode_url($awskey)]}&Expires=$expires&Signature=@{[encode_url($sig)]}";
	my $cmd = qq[curl $curl_options $insecureaws $header --head @{[cq($url)]}];
	print STDERR "$cmd\n" if $v;
	my $head = qx[$cmd];

	print STDERR $head if $v;

	my($code) = $head =~ /^HTTP\/\d+\.\d+\s+(\d+\s+.*?)\r?\n/s;

	if ($code !~ /^2\d\d\s/)
	{
	    print STDERR "$code\n" unless $v;
	    $exit_code = 22;
	    return;
	}

	if ($verb eq HEAD)
	{
	    print $head;
	    return;
	}
    }

    my($content);
    $content = "--upload-file @{[cq($file)]}" if $file;

    if ($verb eq GET && $file)
    {
	if ($file =~ /\/$/ || -d $file)
	{
	    $file .= "/" if $file !~ /\/$/;
	    #Why doesn't #1 work?
	    #$file .= "#1";
	    my($name) = $name =~ /(?:.*\/)?(.*)$/;
	    $file .= $name;
	}
	$content = "--create-dirs --output @{[cq($file)]}";
    }

    # added a case for "mkdir", so that "$name .= $file"  gets defeated
    # in the mkdir case - We don't want the file we are uploading to be
    # appended to the name because we are creating the bucket, and the
    # name is the location constraint file.

    if ($verb eq MKDIR)
    {
	if ($region)
	{
	    $region = {eu => "eu-west-1", us => "us-east-1", uswest => "us-west-1", ap => "ap-southeast-1"}->{lc $region} || $region;
	    ($temp_fh, my $xml) = tempfile(UNLINK => 1);
	    print $temp_fh qq[<CreateBucketConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
				<LocationConstraint>$region</LocationConstraint>
			      </CreateBucketConfiguration>
			      ];
	    $temp_fh->flush;
	    $content = "--upload-file @{[cq($xml)]}";
	}
	$verb = PUT;
    }

    my $data = "$verb\n$content_md5\n$content_type\n$expires\n$header_sign/$uname";

    my($sig, $awskey) = sign($data);

    my $url = "$scheme://$vhost/$vname@{[$vname =~ /\?/? '&': '?']}AWSAccessKeyId=@{[encode_url($awskey)]}&Expires=$expires&Signature=@{[encode_url($sig)]}";
    $url .= "&marker=$marker" if $marker;
    $url .= "&prefix=@{[encode_url($prefix)]}" if $prefix;
    $url .= "&delimiter=$delimiter" if $delimiter;

    return $url if $request;

    # exec() is used because we can, but it doesn't work under Windows:
    # curl.exe runs asynchronously, and control is returned to the caller
    # before the file transfer request is complete.  Thus, for Windows,
    # no exec().

    if ($isGETobj && !$md5 && $isUnix)
    {
	my $cmd = qq[curl $curl_options $insecureaws $header --request $verb $content --location @{[cq($url)]}];
	print STDERR "exec $cmd\n" if $v;
	exec $cmd;
	die;
    }

    # for a PUT, disable the "Expect: 100-Continue" header if the file is small
    my($accept);
    $accept = "--header \"Expect: \"" if $verb eq PUT && (-s $file) < 10_000;

    my $cmd = qq[curl $curl_options $insecureaws $accept $header --request $verb --dump-header - $content --location @{[cq($url)]}];

    print STDERR "$cmd\n" if $v;
    my $item = qx[$cmd];
    exit $? >> 8 if $? && $fail;

    # remove "HTTP/1.1 100 Continue"
    $item =~ s/^HTTP\/\d+\.\d+\s+100\b.*?\r?\n\r?\n//s;

    my($head, $body) = $item =~ /^(.*?\r?\n)\r?\n(.*)$/s;
    print STDERR $head if $v;
    my($code) = $head =~ /^HTTP\/\d+\.\d+\s+(\d+\s+.*?)\r?\n/s;

    if ($code !~ /^2\d\d\s/)
    {
	print STDERR "$code\n" unless $v;
	$exit_code = 22;
	return if $fail;
    }

    if ($md5)
    {
	my($want) = $head =~ /^ETag:\s*"(.*?)"/m;
	if ($want)
	{
	    my($have);
	    if ($body)
	    {
		$have = md5_hex($body);
	    }
	    else
	    {
		$have = (split(" ", qx[md5sum @{[cq($file)]}]))[0];
	    }
	    print STDERR "MD5: checksum is $want\n" if $v;
	    if ($want ne $have)
	    {
		print STDERR "MD5: checksum failed ($want at amz != $have here)\n";
		exit 1 if $fail;
	    }
	}
    }

    $body;
}


sub ec2
{
    my $service = shift;

    $expire_time ||= 30;	# force it to use Expires rather than Timestamp, so it expires more quickly

    my($sec, $min, $hour, $mday, $mon, $year, undef, undef, undef) = gmtime(time + $time_offset + $expire_time);
    my $zulu = sprintf "%04d-%02d-%02dT%02d:%02d:%02dZ", 1900 + $year, $mon + 1, $mday, $hour, $min, $sec;

    my($version, $endpoint);
    $version .= $ec2_version if $service eq "ec2";
    $version .= $sqs_version if $service eq "sqs";
    $version .= $elb_version if $service eq "elb";
    $version .= $sdb_version if $service eq "sdb";
    $version .= $iam_version if $service eq "iam";

    my %data = (AWSAccessKeyId => _, SignatureMethod => HmacSHA1, SignatureVersion => 2, Version => $version, ($expire_time? Expires: Timestamp) => $zulu, @_);

    # see http://developer.amazonwebservices.com/connect/entry!default.jspa?externalID=3912
    $region = {eu => "eu-west-1", us => "us-east-1", uswest => "us-west-1", ap => "ap-southeast-1"}->{lc $region} || $region;

    if ($service eq "ec2")
    {
	$endpoint = "ec2.amazonaws.com";
	$endpoint = "ec2.$region.amazonaws.com" if $region;
    }

    if ($service eq "sqs")
    {
	$endpoint = "queue.amazonaws.com";
	$endpoint = "sqs.$region.amazonaws.com" if $region;
    }

    if ($service eq "elb")
    {
	$endpoint = "elasticloadbalancing.amazonaws.com";
	$endpoint = "elasticloadbalancing.$region.amazonaws.com" if $region;
    }

    if ($service eq "sdb")
    {
	$endpoint = "sdb.amazonaws.com";
	# go figure: us-east-1 isn't name served
	$endpoint = "sdb.$region.amazonaws.com" if $region && $region ne "us-east-1";
    }

    if ($service eq "iam")
    {
	$endpoint = "iam.amazonaws.com";
	$endpoint = "iam.$region.amazonaws.com" if $region;
    }

    $queue ||= "/";

    my($url);

    for (sort keys %data)
    {
	if ($service eq "sqs" && $_ eq "QueueUri")
	{
	    $queue = $data{$_};
	    next;
	}
	$url .= "&" if $url;
	$url .= "$_=@{[encode_url($data{$_})]}";
    }

    my($sig, $awskey) = sign("GET\n$endpoint\n$queue\n$url");
    $url =~ s/(AWSAccessKeyId=?)_/$1$awskey/;
    $url = "$scheme://$endpoint$queue?Signature=@{[encode_url($sig)]}&$url";
    return $url if $request;
    local($/);			# return a string regardless of wantarray
    print "$url\n" if $v >= 2;
    qx[curl $curl_options $insecureaws @{[cq($url)]}];
}


sub encode_url
{
    my($s) = @_;
    $s =~ s/([^\-\.0-9a-z\_\~])/%@{[uc unpack(H2,$1)]}/ig;
    $s;
}

sub decode_url
{
    my($s) = @_;
    $s =~ s/%(..)/@{[uc pack(H2,$1)]}/ig;
    $s;
}

sub dentity
{
    my($s) = @_;
    for ($s)
    {
	s/&\#x([0-9a-f]{1,2});/pack(C, hex($1))/iseg;
	s/&(.*?);/({quot => '"', amp => "&", apos => "'", lt => "<", gt => ">"}->{$1} || "&$1;")/seg;
    }
    $s;
}

sub printable
{
    my($s) = @_;
    $s =~ s/[\x00-\x1f\x7f]/\?/sg;
    $s;
}


sub load_file
{
    my $fn = shift;
    my $io = new IO::File($fn)
	or die "$fn: $!\n";
    local($/);
    <$io>;
}

sub save_file
{
    my $nfn = my $fn = shift;
    $nfn = ">$fn" if $fn !~ /^\s*[\>\|]/;
    my $out = IO::File->new($nfn) or die "$fn: $!\n";
    print $out join("", @_);
}


sub load_file_silent
{
    my $fn = shift;
    my $io = new IO::File($fn) or return;
    local($/);
    <$io>;
}

sub guess_is_unix 
{
    return 1 if $ENV{OS} =~ /windows/i && $ENV{OSTYPE} =~ /cygwin/i;
    return 1 if $ENV{OS} !~ /windows/i;
    return 0;
}

sub get_home_directory
{
    return "$ENV{HOMEDRIVE}$ENV{HOMEPATH}" || "C:" if !$isUnix;
    return (getpwuid($<))[7];
}


sub sign
{
    my($data) = @_;

    my($awskey, $secret, $signurl) = @ENV{qw(AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SIGN_URL)};

    unless ($awskey || $secret || $signurl)
    {
	($awskey, $secret) = @ENV{qw(EC2_ACCESS_KEY EC2_SECRET_KEY)};
    }

    unless ($awskey || $secret || $signurl)
    {
	if ($secrets_file =~ /s3cfg$/)
	{
	    # if the secrets_file ends with s3cfg, treat it as a s3cmd init file
	    # 	(can be tested with --secrets-file=s3cfg)
	    # Poor man's ini parser
	    my $s3cfg = load_file($secrets_file);
	    ($awskey, $secret) = map {$s3cfg =~ /^$_\s*=\s*(\S+)/im} qw/access_key secret_key/;
	}
	else
	{
	    ($awskey, $secret, $signurl) = split(' ', load_file($secrets_file));
	}
    }

    die if $signurl =~ /\'/;

    $data =~ s/(AWSAccessKeyId=?)_/$1$awskey/g;

    if ($v)
    {
	(my $pretty = $data) =~ s/\n/\\n/sg;
	print STDERR "data = $pretty\n";
    }

    if (!exists $ENV{QUERY_STRING} && $signurl)
    {
	(my $pretty = $data) =~ s/\n/\\n/sg;
	(my $url = $signurl) =~ s/\/\/.*?\@/\/\/\*\*\*\*\*\*\:\*\*\*\*\*\*\@/;
	print STDERR "signing [$pretty] via $url\n" if $v;
	my $s = qx[curl $curl_options $insecsign --data @{[cq($data)]} @{[cq($signurl)]}];
	#S9pr7y07SGtgt7OKjMxMYBy+LCk=
	#1B5JPHYQCXW13GWKHAG2
	die "bad signature [$s] from remote signing service (perhaps the password is bad?)\n$s\n" unless $s =~ /^[A-Z0-9\+\/\=\n]+$/i;
	return (split(/\n/, $s));
    }

    (encode_base64(hmac($data, $secret, \&sha1_sha1), ""), $awskey);
}


sub parse_filter
{
    my($name, $value) = $_[0] =~ /^(.*?)=(.*)$/;
    my(@result);
    push @result, "Filter.N.Name" => $name, "Filter.N.Value.1" => $value;
    [@result];
}


sub parse_block_device_mapping
{
    my($dev, $vol, $size, $delete) = $_[0] =~ /^(.*?)(?:=(.*?)(?::(.*?)(?::(.*?))?)?)?$/;
    #print "dev=$dev\nvol=$vol\nsize=$size\ndelete=$delete\n";
    my(@result);

    push @result, "BlockDeviceMapping.N.DeviceName" => $dev;
    if ($vol eq "none")
    {
	push @result, "BlockDeviceMapping.N.NoDevice" => "true";
    }
    elsif ($vol =~ /^ephemeral/)
    {
	push @result, "BlockDeviceMapping.N.VirtualName" => $vol;
    }
    else
    {
	push @result, "BlockDeviceMapping.N.Ebs.SnapshotId" => $vol if $vol;
	push @result, "BlockDeviceMapping.N.Ebs.VolumeSize" => $size if $size;
	push @result, "BlockDeviceMapping.N.Ebs.DeleteOnTermination" => $delete if $delete;
    }
    [@result];
}

sub parse_addpolicy_effect
{
    parse_addpolicy_finish() if @parse_addpolicy_resource;
    $parse_addpolicy_effect = lc $_[0] eq "allow"? "Allow": "Deny";
}
sub parse_addpolicy_action
{
    @parse_addpolicy_action = () if @parse_addpolicy_resource;
    @parse_addpolicy_resource = ();

    parse_addpolicy_finish() if @parse_addpolicy_resource;
    push @parse_addpolicy_action, $_[0];
}
sub parse_addpolicy_resource
{
    push @parse_addpolicy_resource, $_[0];

    my $effect = $parse_addpolicy_effect || "Allow";

    my $action = qq["$parse_addpolicy_action[0]"];
    $action = "[" . join(",", map{qq["$_"]} @parse_addpolicy_action) . "]" if @parse_addpolicy_action > 1;

    my $resource = qq["$parse_addpolicy_resource[0]"];
    $resource = "[" . join(",", map{qq["$_"]} @parse_addpolicy_resource) . "]" if @parse_addpolicy_resource > 1;

    pop @parse_policy if @parse_addpolicy_resource > 1;
    push @parse_policy, qq[\t\t{\n\t\t\t"Effect":"$effect",\n\t\t\t"Action":$action,\n\t\t\t"Resource":$resource\n\t\t}];
    $parse_policy = qq[{\n\t"Statement":\n\t[\n@{[join(",\n", @parse_policy)]}\n\t]\n}\n];
    @final_list = (PolicyDocument, $parse_policy);
}
sub parse_addpolicy_output
{
    print $parse_policy;
}

sub parse_tags
{
    my($key, $value) = split(/=/, $_[0], 2);
    ["Tag.N.Key" => $key, "Tag.N.Value" => $value];
}

sub parse_tags_describe
{
    my($name, $value) = split(/=/, $_[0], 2);
    my @value = split(/,/, $value);
    my(@data);
    push @data, "Filter.N.Name" => $name;
    for (my $i = 1; $i <= @value; $i++)
    {
	push @data, , "Filter.N.Value.$i" => $value[$i - 1];
    }
    \@data;
}

sub parse_tags_delete
{
    if ($_[0] =~ /=/)
    {
	my($name, $value) = split(/=/, $_[0], 2);
	return ["Tag.N.Key" => $name, "Tag.N.Value" => $value];
    }
    ["Tag.N.Key" => $_[0]];
}


sub cq
{
    # quote for sending to curl via shell
    my($s) = @_;
    return "\"$s\"" if !$isUnix;
    $s =~ s/\'/\'\\\'\'/g;
    "'$s'";
}

sub curlq
{
    # quote for sending URL to curl via shell
    my($s) = @_;
    return "\"$s\"" if !$isUnix;
    $s =~ s/[\'\ \+\#]/%@{[unpack(H2, $1)]}/g;
    $s
}


sub xcmp
{
    my($a, $b) = @_? @_: ($a, $b);

    my @a = split(//, $a);
    my @b = split(//, $b);

    for (;;)
    {
        return @a - @b unless @a && @b;

        last if $a[0] cmp $b[0];

        shift @a;
        shift @b;
    }

    my $cmp = $a[0] cmp $b[0];

    for (;;)
    {
        return ($a[0] =~ /\d/) - ($b[0] =~ /\d/) if ($a[0] =~ /\d/) - ($b[0] =~ /\d/);
        last unless (shift @a) =~ /\d/ && (shift @b) =~ /\d/;
    }

    return $cmp;
}


#
# hmac() was taken from the Digest::HMAC CPAN module
# Copyright 1998-2001 Gisle Aas.
# Copyright 1998 Graham Barr.
# This library is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#

sub hmac
{
    my($data, $key, $hash_func, $block_size) = @_;
    $block_size ||= 64;
    $key = &$hash_func($key) if length($key) > $block_size;

    my $k_ipad = $key ^ (chr(0x36) x $block_size);
    my $k_opad = $key ^ (chr(0x5c) x $block_size);

    &$hash_func($k_opad, &$hash_func($k_ipad, $data));
}

#
# end of hmac()
#


#
# sha1() was taken from http://www.movable-type.co.uk/scripts/SHA-1.html
# Copyright 2002-2005 Chris Veness
# You are welcome to re-use these scripts [without any warranty express or implied]
# provided you retain my copyright notice and when possible a link to my website.
#
# Conversion from Javascript
# Copyright 2007 Timothy Kay
#

sub sha1_sha1
{
    # integer arithment should be mod 32
    use integer;

    my $msg = join("", @_);

    #constants [4.2.1]
    my @K = (0x5a827999, 0x6ed9eba1, 0x8f1bbcdc, 0xca62c1d6);

    # PREPROCESSING 
 
    $msg .= pack(C, 0x80); # add trailing '1' bit to string [5.1.1]

    # convert string msg into 512-bit/16-integer blocks arrays of ints [5.2.1]
    my @M = unpack("N*", $msg . pack C3);
    # how many integers are needed (to make complete 512-bit blocks), including two words with length
    my $N = 16 * int((@M + 2 + 15) / 16);
    # add length (in bits) into final pair of 32-bit integers (big-endian) [5.1.1]
    @M[$N - 2, $N - 1] = (sha1_lsr(8 * length($msg), 29), 8 * (length($msg) - 1));

    # set initial hash value [5.3.1]
    my @H = (0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, 0xc3d2e1f0);

    # HASH COMPUTATION [6.1.2]

    for (my $i = 0; $i < $N; $i += 16)
    {
        # 1 - prepare message schedule 'W'
	my @W = @M[$i..$i + 15];

        # 2 - initialise five working variables a, b, c, d, e with previous hash value
	my($a, $b, $c, $d, $e) = @H;

        # 3 - main loop
	for (my $t = 0; $t < 80; $t++)
	{
	    $W[$t] = sha1_rotl($W[$t - 3] ^ $W[$t - 8] ^ $W[$t - 14] ^ $W[$t - 16], 1) if $t >= 16;
	    my $s = int($t / 20); # seq for blocks of 'f' functions and 'K' constants
	    my $T = sha1_rotl($a, 5) + sha1_f($s, $b, $c, $d) + $e + $K[$s] + $W[$t];
	    ($e, $d, $c, $b, $a) = ($d, $c, sha1_rotl($b, 30), $a, $T);
	}

        # 4 - compute the new intermediate hash value
	$H[0] += $a;
	$H[1] += $b;
	$H[2] += $c;
	$H[3] += $d;
	$H[4] += $e;
    }

    pack("N*", @H);
}

#
# function 'f' [4.1.1]
#
sub sha1_f
{
    my($s, $x, $y, $z) = @_;

    return ($x & $y) ^ (~$x & $z) if $s == 0;
    return $x ^ $y ^ $z if $s == 1 || $s == 3;
    return ($x & $y) ^ ($x & $z) ^ ($y & $z) if $s == 2;
}

#
# rotate left (circular left shift) value x by n positions [3.2.5]
#
sub sha1_rotl
{
    my($x, $n) = @_;
    ($x << $n) | (($x & 0xffffffff) >> (32 - $n));
}

#
# logical shift right value x by n positions
# done using floating point, so that it works for more than 32 bits
#
sub sha1_lsr
{
    no integer;
    my($x, $n) = @_;
    $x / 2 ** $n;
}

#
# end of sha1()
#


#
# Jim Dannemiller says MIME::Base64 was missing from the Perl installation
# on a small Linux handheld, so I added this code here instead of including
# MIME::Base64.
#
# Copyright 1995-1999, 2001-2004 Gisle Aas.
#
# This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.
#
# Distantly based on LWP::Base64 written by Martijn Koster <m.koster@nexor.co.uk> and Joerg Reichelt <j.reichelt@nexor.co.uk>
# and code posted to comp.lang.perl <3pd2lp$6gf@wsinti07.win.tue.nl> by Hans Mulder <hansm@wsinti07.win.tue.nl>
#

sub encode_base64 ($;$)
{
    if ($] >= 5.006) {
	require bytes;
	if (bytes::length($_[0]) > length($_[0]) ||
	        ($] >= 5.008 && $_[0] =~ /[^\0-\xFF]/))
	{
	    require Carp;
	    Carp::croak("The Base64 encoding is only defined for bytes");
	}
    }

    use integer;

    my $eol = $_[1];
    $eol = "\n" unless defined $eol;

    my $res = pack("u", $_[0]);
    # Remove first character of each line, remove newlines
    $res =~ s/^.//mg;
    $res =~ s/\n//g;

    $res =~ tr|` -_|AA-Za-z0-9+/|;               # `# help emacs
    # fix padding at the end
    my $padding = (3 - length($_[0]) % 3) % 3;
    $res =~ s/.{$padding}$/'=' x $padding/e if $padding;
    # break encoded string into lines of no more than 76 characters each
    if (length $eol) {
	$res =~ s/(.{1,76})/$1$eol/g;
    }
    return $res;
}

sub decode_base64 ($)
{
    local($^W) = 0; # unpack("u",...) gives bogus warning in 5.00[123]
    use integer;

    my $str = shift;
    $str =~ tr|A-Za-z0-9+=/||cd;            # remove non-base64 chars
    if (length($str) % 4) {
	require Carp;
      Carp::carp("Length of base64 data not a multiple of 4")
      }
    $str =~ s/=+$//;                        # remove padding
    $str =~ tr|A-Za-z0-9+/| -_|;            # convert to uuencoded format
    return "" unless length $str;

    ## I guess this could be written as
    #return unpack("u", join('', map( chr(32 + length($_)*3/4) . $_,
    #$str =~ /(.{1,60})/gs) ) );
    ## but I do not like that...
    my $uustr = '';
    my ($i, $l);
    $l = length($str) - 60;
    for ($i = 0; $i <= $l; $i += 60) {
	$uustr .= "M" . substr($str, $i, 60);
    }
    $str = substr($str, $i);
    # and any leftover chars
    if ($str ne "") {
	$uustr .= chr(32 + length($str)*3/4) . $str;
    }
    return unpack ("u", $uustr);
}

#
# end of encode_base64()
#

