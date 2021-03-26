import { NativeModules } from 'react-native';

type DtPickerType = {
  multiply(a: number, b: number): Promise<number>;
};

const { DtPicker } = NativeModules;

export default DtPicker as DtPickerType;
