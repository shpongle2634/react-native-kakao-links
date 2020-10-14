declare module '@miso/react-native-kakao-link' {
  export type LinkObject = {
    webURL?: string;
    mobileWebURL?: string;
    androidExecutionParams?: string;
    iosExecutionParams?: string;
  };

  export type ContentObject = {
    title: string;
    link: LinkObject;
    imageURL: string;
    desc?: string;
    imageWidth?: number;
    imageHeight?: number;
  };

  export type SocialObject = {
    likeCount?: number;
    commentCount?: number;
    sharedCount?: number;
    viewCount?: number;
    subscriberCount?: number;
  };

  export type ButtonObject = {
    title: string;
    link: LinkObject;
  };

  export type CommerceDetailObject = {
    regularPrice?: number;
    discountPrice?: number;
    discountRate?: number;
    fixedDiscountPrice?: number;
  };

  export type FeedTemplate = {
    objectType: 'feed';
    content: ContentObject;
    social?: SocialObject;
    buttons?: Array<ButtonObject>;
  };

  export type ListTemplate = {
    objectType: 'list';
    headerTitle: string;
    headerLink: LinkObject;
    contents: Array<ContentObject>;
    buttons?: Array<ButtonObject>;
  };

  export type LocationTemplate = {
    objectType: 'location';
    content: ContentObject;
    address: string;
    addressTitle?: string;
    buttons?: Array<ButtonObject>;
  };

  export type CommerceTemplete = {
    objectType: 'commerce';
    content: ContentObject;
    commerce: CommerceDetailObject;
    buttons?: Array<ButtonObject>;
  };

  export type TextTemplate = {
    objectType: 'text';
    text: string;
    link: LinkObject;
    buttons?: Array<ButtonObject>;
  };

  export type LinkOptions = FeedTemplate | ListTemplate | LocationTemplate | CommerceTemplete | TextTemplate;

  export default class RNKakaoLink {
    public static link(options: LinkOptions): Promise<Record<string, unknown>>;
  }
}
